// AR furniture List

package com.google.ar.sceneform.samples.gltf;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;


// AR Viewer list

public class ListARActivity extends AppCompatActivity {

    ArrayList<SampleData> dataList; // 실제로 list 내 데이터를 저장하게 될 type이 SampleData인 ArrayList 객체 생성

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_list_aractivity);// 레이아웃 정의한 레이아웃 리소스를 사용하여 현재 액티비티의 화면 구성

        this.InitializeData(); // Initialize

        ListView listView = (ListView) findViewById(R.id.listview); // 레이아웃 파일에 정의된 listview
        final ListAdapter listadapter = new ListAdapter(this, dataList); // ListAdapter extends BasicAdapter -> ListAdapter.java

        listView.setAdapter(listadapter); // listview 객체에 Listadapter 객체 연결

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() { // Click Item
            @Override
            public void onItemClick(AdapterView parent, View view, int position, long l) {
                System.out.println("--------------------------------------페이지 실행--------------------------------------------");
                Intent intent = new Intent(ListARActivity.this, GltfActivity.class); // ListARActivity -> GltfActivity data 이동
                intent.putExtra("key", listadapter.getItem(position).getKey());
                intent.putExtra("size", listadapter.getItem(position).getSize()); // 상품의 key, size 전달

                startActivity(intent);

//                Toast.makeText(getApplicationContext(), listadapter.getItem(position).getFullName(), Toast.LENGTH_LONG).show();
            }
        });
    }

    public void InitializeData(){
        dataList = new ArrayList<SampleData>();

        dataList.add(new SampleData(R.drawable.i668317, 0, "한샘 하이 엠마 천연가죽 3인용 소파", 211));
        dataList.add(new SampleData(R.drawable.i668318, 1, "한샘 하이 엠마 천연가죽 4인용 소파", 301));
        dataList.add(new SampleData(R.drawable.i681946, 2, "한샘 하이 모먼트 헤드무빙 천연가죽 소파 4인용", 285));
        dataList.add(new SampleData(R.drawable.i681947, 3, "한샘 하이 모먼트 헤드무빙 천연가죽 소파 3인용", 210));
        dataList.add(new SampleData(R.drawable.i737686, 4, "한샘 하이 브리오 이태리 천연가죽 4인용 소파", 285));
        dataList.add(new SampleData(R.drawable.i737687, 5, "한샘 하이 브리오 이태리 천연가죽 3.5인용 소파", 240));
        dataList.add(new SampleData(R.drawable.i746525, 6, "한샘 프라임 노블 천연면피가죽 전동 리클라이너 소파 4인용", 263));
        dataList.add(new SampleData(R.drawable.i746526, 7, "한샘 프라임 노블 천연면피가죽 전동 리클라이너 소파 3인용", 192));
        dataList.add(new SampleData(R.drawable.i746540, 8, "한샘 프라임 리츠 천연면피가죽 전동 리클라이너 소파 4인용", 263));
        dataList.add(new SampleData(R.drawable.i746541, 9, "한샘 프라임 리츠 천연면피가죽 전동 리클라이너 소파 3인용", 192));
        dataList.add(new SampleData(R.drawable.i772973, 10, "한샘 클로즈 침대 SS 슈퍼싱글 코튼그레이", 116));
        dataList.add(new SampleData(R.drawable.i777039, 11, "한샘 밀로 패브릭소파 3인용", 200));
        dataList.add(new SampleData(R.drawable.i777040, 12, "한샘 밀로 패브릭소파 4인용", 280));
        dataList.add(new SampleData(R.drawable.i786840, 13, "한샘 모아 모듈형 패브릭소파 3인용", 252));
        dataList.add(new SampleData(R.drawable.i786841, 14, "한샘 모아 모듈형 패브릭소파 3인 카우치", 252));
        dataList.add(new SampleData(R.drawable.i786842, 15, "한샘 모아 모듈형 패브릭소파 4인 오픈형", 280));
        dataList.add(new SampleData(R.drawable.i787819, 16, "한샘 듀이 아르떼 패브릭소파 4인 카우치", 301));
        dataList.add(new SampleData(R.drawable.i787823, 17, "한샘 듀이 아르떼 패브릭소파 4인용", 301));
        dataList.add(new SampleData(R.drawable.i796379, 18, "한샘 엠마 테일러 천연면피가죽 4인용 소파", 278));
        dataList.add(new SampleData(R.drawable.i796416, 19, "한샘 엠마 테일러 천연면피가죽 3인용 소파", 185));
        dataList.add(new SampleData(R.drawable.i799215, 20, "한샘 엠마 컴포트 천연면피가죽 3인용 소파", 200));
        dataList.add(new SampleData(R.drawable.i799220, 21, "한샘 엠마 컴포트 천연면피가죽 4인용 소파", 268));
    }
}