package in.liquidlab.liquidpark;

import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.widget.TextView;
import android.widget.Toast;

import java.util.concurrent.ExecutionException;

public class ZoneActivity extends AppCompatActivity {
    TextView txt1,txt2,txt3, txt4,txt5, txt6,txt7, txt8, txt9;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_zone);

        txt1 = (TextView) findViewById(R.id.txtTotal1);
        txt2 = (TextView) findViewById(R.id.txtAvailable1);
        txt3 = (TextView) findViewById(R.id.txtOccupied);
        txt4 = (TextView) findViewById(R.id.txtTotal2);
        txt5 = (TextView) findViewById(R.id.txtAvailable2);
        txt6 = (TextView) findViewById(R.id.txtOccupied2);
        txt7 = (TextView) findViewById(R.id.txtTotal3);
        txt8 = (TextView) findViewById(R.id.txtAvailable3);
        txt9 = (TextView) findViewById(R.id.txtOccupied3);

        final Handler handler = new Handler();
        Runnable runnable = new Runnable() {

            @Override
            public void run() {
                try {
                    String authUrl = "http://lpclouddb.cloudapp.net/PGSWebAPI/api/parking/gzones%7C1";
                    RequestTask task = (RequestTask) new RequestTask().execute(authUrl);

                    try {
                        if (task.get() == null) {
                            PopupMessage("No Connection");
                        }
                        else
                        {
                            String data = task.get().replace('"', ' ').trim();
                            txt1.setText(data.split(",")[1]);
                            txt2.setText(data.split(",")[2]);
                            txt3.setText(data.split(",")[3].replace("{Zone2", "").replace("}", ""));
                            txt4.setText(data.split(",")[4]);
                            txt5.setText(data.split(",")[5]);
                            txt6.setText(data.split(",")[6].replace("{Zone3", "").replace("}", ""));
                            txt7.setText(data.split(",")[7]);
                            txt8.setText(data.split(",")[8]);
                            txt9.setText(data.split(",")[9].replace("}}", ""));
                        }
                    }
                    catch (InterruptedException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                    catch (ExecutionException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                } catch (Exception e) {
                    // TODO: handle exception
                } finally {
                    //also call the same runnable to call it at regular interval
                    handler.postDelayed(this, 10000);
                }
            }
        };
        handler.postDelayed(runnable, 1000);
    }

    public void PopupMessage(final String message) {
        this.runOnUiThread(new Runnable() {
            public void run() {
                Toast.makeText(getApplicationContext(), message, Toast.LENGTH_SHORT).show();
            }
        });
        finish();
    }
}
