import java.lang.reflect.Method;
import android.media.AudioManager;

AudioManager am = (AudioManager)getSystemService(Context.AUDIO_SERVICE);
try{
	Method m = am.getClass().getMethod("getOutputLatency", int.class);
	latency = (Integer)m.invoke(am, AudioManager.STREAM_MUSIC);
}catch(Exception e){
}