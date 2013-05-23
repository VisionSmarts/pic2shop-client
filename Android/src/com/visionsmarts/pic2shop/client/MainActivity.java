package com.visionsmarts.pic2shop.client;

import static android.view.View.GONE;
import static android.view.View.VISIBLE;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.TextView;

public class MainActivity extends Activity implements OnClickListener {

	private static final String TAG = MainActivity.class.getName();
	private static final int REQUEST_CODE_SCAN = 1405;

	private CheckBox eanAndUpcCheckBox, ean8CheckBox, upceCheckBox,
			itfCheckBox, code39CheckBox, code128CheckBox, codabarCheckBox,
			qrCheckBox;
	private Button scanWithFreeButton, installFreeScannerButton,
			scanWithProButton, installProScannerButton, buttonLaunchUrlIntent;
	private TextView resultTextView;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		//
		eanAndUpcCheckBox = (CheckBox) findViewById(R.id.checkbox_ean_and_upc);
		ean8CheckBox = (CheckBox) findViewById(R.id.checkbox_ean8);
		upceCheckBox = (CheckBox) findViewById(R.id.checkbox_upce);
		itfCheckBox = (CheckBox) findViewById(R.id.checkbox_itf);
		code39CheckBox = (CheckBox) findViewById(R.id.checkbox_code39);
		code128CheckBox = (CheckBox) findViewById(R.id.checkbox_code128);
		codabarCheckBox = (CheckBox) findViewById(R.id.checkbox_codabar);
		qrCheckBox = (CheckBox) findViewById(R.id.checkbox_qr);
		scanWithFreeButton = (Button) findViewById(R.id.button_scan_with_free_pic2shop);
		installFreeScannerButton = (Button) findViewById(R.id.button_install_free_pic2shop);
		scanWithProButton = (Button) findViewById(R.id.button_scan_with_pic2shop_pro);
		installProScannerButton = (Button) findViewById(R.id.button_install_pic2shop_pro);
		buttonLaunchUrlIntent = (Button) findViewById(R.id.button_launch_url_intent);
		resultTextView = (TextView) findViewById(R.id.textview_result);
		//
		scanWithFreeButton.setOnClickListener(this);
		installFreeScannerButton.setOnClickListener(this);
		scanWithProButton.setOnClickListener(this);
		installProScannerButton.setOnClickListener(this);
		buttonLaunchUrlIntent.setOnClickListener(this);
	}

	@Override
	protected void onResume() {
		super.onResume();
		if (Utils.isFreeScannerAppInstalled(this)) {
			scanWithFreeButton.setVisibility(VISIBLE);
			installFreeScannerButton.setVisibility(GONE);
		} else {
			scanWithFreeButton.setVisibility(GONE);
			installFreeScannerButton.setVisibility(VISIBLE);
		}
		if (Utils.isProScannerAppInstalled(this)) {
			scanWithProButton.setVisibility(VISIBLE);
			installProScannerButton.setVisibility(GONE);
		} else {
			scanWithProButton.setVisibility(GONE);
			installProScannerButton.setVisibility(VISIBLE);
		}
		int extraFormatsVisibility = Utils.isProScannerAppInstalled(this) ? VISIBLE
				: GONE;
		for (CheckBox cb : new CheckBox[] { ean8CheckBox, upceCheckBox,
				itfCheckBox, code39CheckBox, code128CheckBox, codabarCheckBox,
				qrCheckBox }) {
			cb.setVisibility(extraFormatsVisibility);
		}
	}

	@Override
	public void onClick(View v) {
		if (v == scanWithFreeButton) {
			Intent intent = new Intent(Scan.ACTION);
			startActivityForResult(intent, REQUEST_CODE_SCAN);
		} else if (v == installFreeScannerButton) {
			Utils.launchMarketToInstallFreeScannerApp(this);
		} else if (v == scanWithProButton) {
			Intent intent = new Intent(Scan.Pro.ACTION);
			intent.putExtra(Scan.Pro.FORMATS, getCheckedFormats());
			startActivityForResult(intent, REQUEST_CODE_SCAN);
		} else if (v == installProScannerButton) {
			Utils.launchMarketToInstallProScannerApp(this);
		} else if (v == buttonLaunchUrlIntent) {
			Intent intent = new Intent(
					Intent.ACTION_VIEW,
					Uri.parse("p2spro://scan?formats=EAN13,EAN8,UPCE,ITF,CODE39,CODE128,CODABAR,QR&callback=http%3A%2F%2Fdemo.pic2shop.com%2Fdumpargs.php%3Fc%3DCODE%26f%3DFORMAT"));
			startActivity(intent);
		} else {
			Log.e(TAG, "Wrong Button tapped.");
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == REQUEST_CODE_SCAN && resultCode == RESULT_OK) {
			String barcode = data.getStringExtra(Scan.BARCODE);
			String barcodeFormat = data.getStringExtra(Scan.Pro.FORMAT);
			Log.d(TAG, "Scanned barcode: " + barcode + " of format: "
					+ barcodeFormat);
			String resultText = barcode;
			if (barcodeFormat != null) {
				resultText += "\n" + barcodeFormat;
			}
			resultTextView.setText(resultText);
		}
	}

	private String[] getCheckedFormats() {
		ArrayList<String> barcodeTypes = new ArrayList<String>();
		String[] barcodeTypesArr = getResources().getStringArray(
				R.array.barcode_types_vals);
		CheckBox[] checkBoxes = new CheckBox[] { eanAndUpcCheckBox,
				ean8CheckBox, upceCheckBox, itfCheckBox, code39CheckBox,
				code128CheckBox, codabarCheckBox, qrCheckBox };
		for (int i = 0; i < checkBoxes.length; i++) {
			CheckBox cb = checkBoxes[i];
			if (cb.isChecked()) {
				barcodeTypes.add(barcodeTypesArr[i]);
			}
		}
		return barcodeTypes.toArray(new String[barcodeTypes.size()]);
	}

}