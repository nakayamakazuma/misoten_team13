﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using TrueSync;


public class ParticleManager : TrueSyncBehaviour
{
    [System.Serializable]   
    public class EffectInf
    {

        public int waitTime;
        public GameObject obj;


    }
    public List<EffectInf> ParticleList;
    Dictionary<string, EffectInf> ParticleDic = new Dictionary<string, EffectInf>();
    Vector3 pos;
    GameObject target;
   
    private void Start()
    {
        pos = new Vector3(0.0f, 0.0f, 0.0f);
        target = GameObject.FindWithTag("SetAR");
        //リスト作成
        foreach (var particle in ParticleList)
        {
            ParticleDic.Add(particle.obj.name, particle);
        }

    }

    // 指定の座標で再生
    public void Play(string particleName, Vector3 position ,bool roop = false)
    {
        StartCoroutine(WaitFunction(particleName, position, roop));

       

    }

    IEnumerator WaitFunction(string particleName, Vector3 position, bool roop = false)
    {
        yield return new WaitForFrame(ParticleDic[particleName].waitTime);
        GameObject particle = Instantiate(ParticleDic[particleName].obj);

        particle.transform.SetParent(target.transform);

        particle.transform.position = position;


        ParticleSystem ps = particle.GetComponent<ParticleSystem>();

        if (roop)
        {
            StartCoroutine(WaitDestroy(ps.time, particle));

        }
        else
        {
            TrueSyncManager.Destroy(particle, ps.duration);
            // パーティクルが終わり次第削除
   
        }
       
    }

    IEnumerator WaitDestroy(float frame, GameObject obj)
    {
        yield return new WaitForSeconds(frame);
        TrueSyncManager.SyncedDestroy(obj);
    }


    void Update()
    {
       
    }

    internal void Play(string v)
    {
        throw new NotImplementedException();
    }
}