package in.liquidlab.liquidpark;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import java.util.concurrent.ExecutionException;

public class MainActivity extends AppCompatActivity {

    TextView txt1,txt2,txt3, txt4,txt5,txt6;
    Button b1;
    ProgressBar pb1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Helper.GCMSenderId = "361344693527";

        txt1 = (TextView) findViewById(R.id.txtTotal);
        txt2 = (TextView) findViewById(R.id.txtAvailable);
        txt4 = (TextView) findViewById(R.id.textView6);
        txt5 = (TextView) findViewById(R.id.textView9);
        txt3 = (TextView) findViewById(R.id.txtOccupied);
        txt6 = (TextView) findViewById(R.id.textView21);
        b1 = (Button) findViewById(R.id.btnZone);
        pb1 = (ProgressBar) findViewById(R.id.progressBarAvailable);

        b1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainActivity.this, ZoneActivity.class);
                startActivity(intent);
            }
        });

                final Handler handler = new Handler();
                 Runnable runnable = new Runnable() {

                     @Override
                     public void run() {
                         try {
                             String authUrl = "http://lpclouddb.cloudapp.net/PGSWebAPI/api/parking/gparking";
                             RequestTask task = (RequestTask) new RequestTask().execute(authUrl);

                             try {
                                 if (task.get() == null) {
                                     PopupMessage("No Connection");
                                 } else {
                                     String data = task.get().replace('"', ' ').trim();

                                     double total = Double.parseDouble(data.split(",")[1]);
                                     double available = Double.parseDouble(data.split(",")[2]);

                                     txt1.setText(data.split(",")[1]);
                                     txt2.setText(data.split(",")[2]);
                                     txt3.setText(data.split(",")[3].replace('}', ' '));
                                     txt4.setText(data.split(",")[1]);
                                     txt5.setText(data.split(",")[2]);

                                     Double progress = available / total * 100;
                                     int p = progress.intValue();

                                     pb1.setProgress(p);

                                     txt6.setText(p + "%");
                                 }

                             } catch (InterruptedException e) {
                                 // TODO Auto-generated catch block
                                 e.printStackTrace();
                             } catch (ExecutionException e) {
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
