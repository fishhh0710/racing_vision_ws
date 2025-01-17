#include <ros/ros.h>
#include <dynamic_reconfigure/server.h>
#include <camera_dynamic/CameraConfig.h>
#include <cstdlib> 

void setCameraParameter(const std::string& parameter, int value) {
    std::string command = "v4l2-ctl --set-ctrl=" + parameter + "=" + std::to_string(value);
    if (system(command.c_str()) != 0) {
        ROS_ERROR("Failed to set %s to %d", parameter.c_str(), value);
    }
}

void callback(camera_dynamic::CameraConfig &config, uint32_t level) {
    ROS_INFO("Reconfigure Request: %d %d %d %d %d %d %d",             
             config.brightness, 
             config.saturation,             
             config.hue,             
             config.white_balance_automatic,
             config.gamma,
             config.gain,
             config.auto_exposure
    );

    setCameraParameter("brightness", config.brightness);
    setCameraParameter("saturation", config.saturation);
    setCameraParameter("hue", config.hue);
    setCameraParameter("white_balance_automatic", config.white_balance_automatic);
    setCameraParameter("gamma", config.gamma);
    setCameraParameter("gain", config.gain);
    setCameraParameter("auto_exposure", config.auto_exposure);
}

int main(int argc, char **argv) {
    ros::init(argc, argv, "camera_dynamic");
    dynamic_reconfigure::Server<camera_dynamic::CameraConfig> server;    
    dynamic_reconfigure::Server<camera_dynamic::CameraConfig>::CallbackType f;    
    f = boost::bind(&callback, _1, _2);    
    server.setCallback(f);    
    ROS_INFO("Spinning node");    
    ros::spin();    
    return 0;
}
