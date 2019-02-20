using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Clock : MonoBehaviour {
  const float degreesPerHour = 30f;
  const float degreesPerMinute = 6f;
  const float degreesPerSecond = 6f;

  public Transform hoursTransform;
  public Transform minutesTransform;
  public Transform secondsTransform;
  public bool updateContinuous;

  // Start is called before the first frame update
  void Start() {
    UpdateDiscrete();
  }

  // Update is called once per frame
  void Update() {
    if (updateContinuous)
      UpdateContinuous();
    else
      UpdateDiscrete();
  }

  void UpdateDiscrete()
  {
    var now = DateTime.Now;
    hoursTransform.localRotation = Quaternion.Euler(0f, now.Hour * degreesPerHour, 0f);
    minutesTransform.localRotation = Quaternion.Euler(0f, now.Minute * degreesPerMinute, 0f);
    secondsTransform.localRotation = Quaternion.Euler(0f, now.Second * degreesPerSecond, 0f);
  }

  void UpdateContinuous()
  {
    TimeSpan ts = DateTime.Now.TimeOfDay;
    hoursTransform.localRotation = Quaternion.Euler(0f, (float)ts.TotalHours * degreesPerHour, 0f);
    minutesTransform.localRotation = Quaternion.Euler(0f, (float)ts.TotalMinutes * degreesPerMinute, 0f);
    secondsTransform.localRotation = Quaternion.Euler(0f, (float)ts.TotalSeconds * degreesPerSecond, 0f);
  }
}
