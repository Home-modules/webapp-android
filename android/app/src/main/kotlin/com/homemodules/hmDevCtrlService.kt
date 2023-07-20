import com.homemodules.MainActivity
import android.service.controls.Control
import android.service.controls.ControlsProviderService
import android.service.controls.actions.ControlAction
import android.service.controls.DeviceTypes
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.channels.BufferOverflow
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.Calendar
import java.util.concurrent.Flow
import java.util.concurrent.Flow.Publisher
import android.provider.AlarmClock.EXTRA_MESSAGE
import java.util.function.Consumer
import android.app.PendingIntent
import android.content.Intent
import kotlinx.coroutines.delay
import android.service.controls.templates.*
import java.util.Locale

private const val LIGHT_ID = 6969
private const val LIGHT_TITLE = "a"
private const val LIGHT_TYPE = DeviceTypes.TYPE_LIGHT
private val job = SupervisorJob()
private val scope = CoroutineScope(Dispatchers.IO + job)
private val controlFlows = mutableMapOf<String, MutableSharedFlow<Control>>()

private var toggleState = false
private var rangeState = 18f

class hmDevCtrlService : ControlsProviderService() {

    override fun createPublisherForAllAvailable(): Flow.Publisher<Control> {
        return Flow.Publisher {
            (createStatelessControl(LIGHT_ID, LIGHT_TITLE, LIGHT_TYPE))
        }
    }
    private fun createStatelessControl(id: Int, title: String, type: Int): Control {
        val intent = Intent(this, MainActivity::class.java)
            .putExtra(EXTRA_MESSAGE, title)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        val action = PendingIntent.getActivity(
            this,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return Control.StatelessBuilder(id.toString(), action)
            .setTitle(title)
            .setDeviceType(type)
            .build()
    }

     override fun createPublisherFor(controlIds: MutableList<String>): Flow.Publisher<Control> {
        val flow : MutableSharedFlow<Control> = MutableSharedFlow(replay = 2, extraBufferCapacity = 2);

        controlIds.forEach { controlFlows[it] = flow }

        scope.launch {
            delay(1000) // Retrieving the toggle state.
            flow.tryEmit(createLight())
        }
        return Flow.Publisher<Control> {}
    }
    @OptIn(kotlin.ExperimentalStdlibApi::class)
    private fun createLight() = createStatefulControl(
        LIGHT_ID,
        LIGHT_TITLE,
        LIGHT_TYPE,
        toggleState,
        ToggleTemplate(
            LIGHT_ID.toString(),
            ControlButton(
                toggleState,
                toggleState.toString().uppercase(Locale.getDefault())
            )
        )
    )
    private fun  createStatefulControl(id: Int, title: String, type: Int, state: Boolean, template: ControlTemplate): Control {
        val intent = Intent(this, MainActivity::class.java)
            .putExtra(EXTRA_MESSAGE, "$title $state")
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        val action = PendingIntent.getActivity(
            this,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return Control.StatefulBuilder(id.toString(), action)
            .setTitle(title)
            .setDeviceType(type)
            .setStatus(Control.STATUS_OK)
            .setControlTemplate(template)
            .build()
    }

    override fun onDestroy() {
        super.onDestroy()
        job.cancel()
    }
    override fun performControlAction(
        controlId: String,
        action: ControlAction,
        consumer: Consumer<Int>
    ) {
        controlFlows[controlId]?.let { flow ->
            when (controlId) {
                LIGHT_ID.toString() -> {
                    consumer.accept(ControlAction.RESPONSE_OK)
                    // if (action is ControlAction) toggleState = action.newState
                    flow.tryEmit(createLight())
                }
                else -> {
                    consumer.accept(ControlAction.RESPONSE_FAIL)
                }
            }
        } ?: consumer.accept(ControlAction.RESPONSE_FAIL)
    }
}