package in.liquidlab.liquidpark;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.annotation.TargetApi;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.app.LoaderManager.LoaderCallbacks;

import android.content.CursorLoader;
import android.content.Loader;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;

import android.os.Build;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.EditorInfo;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.gcm.GoogleCloudMessaging;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import static android.Manifest.permission.READ_CONTACTS;

/**
 * A login screen that offers login via email/password.
 */
public class LoginActivity extends Activity {
    Button b1;
    EditText et1,et2;
    ProgressDialog progressBarSignIn;
    private int progressBarStatusSignIn = 0;
    private Handler progressBarHandlerSignIn = new Handler();
    private InstanceIdHelper mInstanceIdHelper;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        Helper.GCMSenderId = "361344693527";
        mInstanceIdHelper = new InstanceIdHelper(this);
        mInstanceIdHelper.getTokenInBackground(Helper.GCMSenderId, GoogleCloudMessaging.INSTANCE_ID_SCOPE, null);

        new Thread(new Runnable() {
            public void run() {
                b1 = (Button) findViewById(R.id.btnLogin);
                et1 = (EditText) findViewById(R.id.etUserName);
                et2 = (EditText) findViewById(R.id.etPassword);

                Helper.Key = ReadFromCache();
                if (Helper.Key.equals("true")) {
                    Intent intent = new Intent(LoginActivity.this, MainActivity.class);
                    startActivity(intent);
                } else {
                    b1.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {

                            // prepare for a progress bar dialog
                            progressBarSignIn = new ProgressDialog(v.getContext());
                            progressBarSignIn.setCancelable(true);
                            progressBarSignIn.setMessage("Signing in...");
                            progressBarSignIn.setProgressStyle(ProgressDialog.STYLE_SPINNER);
                            progressBarSignIn.setProgress(0);
                            progressBarSignIn.setMax(100);
                            progressBarSignIn.show();

                            new Thread(new Runnable() {
                                public void run() {
                                    while (progressBarStatusSignIn < 100) {
                                        String authUrl = "http://lpclouddb.cloudapp.net/PGSWebAPI/api/login/authenticate%7C" +
                                                et1.getText().toString() + "%7C" + et2.getText().toString();
                                        RequestTask task = (RequestTask) new RequestTask().execute(authUrl);

                                        try {
                                            if(task.get() == null) {
                                                PopupMessage("No Connection");
                                                LoginActivity.this.finish();
                                            }
                                        else {
                                                Helper.Key = task.get().replace('"', ' ').trim();
                                            }
                                            if (Helper.Key.equals("true")) {
                                                WriteToCache(Helper.Key);

                                                String registerUrl = "http://lpclouddb.cloudapp.net/PGSWebAPI/api/login/register%7C" + Helper.GCMToken;
                                                RequestTask registerTask = (RequestTask) new RequestTask().execute(registerUrl);

                                                try
                                                {
                                                    registerTask.get();
                                                }
                                                catch (InterruptedException e)
                                                {
                                                    // TODO Auto-generated catch block
                                                    e.printStackTrace();
                                                } catch (ExecutionException e) {
                                                    // TODO Auto-generated catch block
                                                    e.printStackTrace();
                                                }
                                            }
                                        } catch (InterruptedException e) {
                                            // TODO Auto-generated catch block
                                            e.printStackTrace();
                                        } catch (ExecutionException e) {
                                            // TODO Auto-generated catch block
                                            e.printStackTrace();
                                        }

                                        if (Helper.Key.equals("true")) {
                                            Intent intent = new Intent(LoginActivity.this, MainActivity.class);
                                            startActivity(intent);
                                        }
                                        else
                                        {
                                            PopupMessage("Wrong Credentials!");
                                        }

                                        progressBarStatusSignIn = 100;

                                        // Update the progress bar
                                        progressBarHandlerSignIn.post(new Runnable() {
                                            public void run() {
                                                progressBarSignIn.setProgress(progressBarStatusSignIn);
                                            }
                                        });
                                    }

                                    // ok, file is downloaded,
                                    if (progressBarStatusSignIn >= 100) {
                                        // close the progress bar dialog
                                        progressBarSignIn.dismiss();
                                    }
                                }
                            }).start();
                        }
                    });
                }
            }
        }).start();
    }

    public void PopupMessage(final String message)
    {
        this.runOnUiThread(new Runnable() {
            public void run() {
                Toast.makeText(getApplicationContext(), message, Toast.LENGTH_SHORT).show();
            }
        });
        finish();
    }

    public String ReadFromCache()
    {
        try
        {
            String strLine="";
            StringBuilder key = new StringBuilder();

            /** Getting Cache Directory */
            File cDir = getBaseContext().getCacheDir();
            /** Getting a reference to temporary file, if created earlier */
            File tempFile = new File(cDir.getPath() + "/LiquidPark.txt");
            FileReader fReader = new FileReader(tempFile);
            BufferedReader bReader = new BufferedReader(fReader);

            /** Reading the contents of the file , line by line */
            while( (strLine=bReader.readLine()) != null  ) {
                key.append(strLine.replace('"',' ').trim());
            }

            return key.toString();
        }
        catch (IOException e)
        {
            e.printStackTrace();
            return "";
        }
    }

    public void WriteToCache(String key)
    {
        try
        {
            /** Getting Cache Directory */
            File cDir = getBaseContext().getCacheDir();
            /** Getting a reference to temporary file, if created earlier */
            File tempFile = new File(cDir.getPath() + "/LiquidPark.txt");
            FileWriter writer = new FileWriter(tempFile);
            /** Saving the contents to the file*/
            writer.write(key);
            /** Closing the writer object */
            writer.close();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }
}

