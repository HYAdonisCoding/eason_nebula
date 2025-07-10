# -*- coding: utf-8 -*-
import pandas as pd
import json
import os

# 当前文件目录
current_dir = os.path.dirname(os.path.abspath(__file__))

# Path to the JSON file
file_path = os.path.join(current_dir, "cars.json")

print(f"Reading data from {file_path}")
# Read the content of the JSON file
with open(file_path, "r") as file:
    cars_data = json.load(file)

# Display the first few entries to understand the structure of the data
cars_data[:5] if isinstance(cars_data, list) else cars_data
# Extracting the relevant data from the cars_data
data = []
for car in cars_data["result"]["datalist"]:
    spec_name = car["specname"]
    param_list = car["paramconflist"]
    param_dict = {
        param["itemname"]: param["itemname"] if "itemname" in param else ""
        for param in param_list
    }

    # Only include the key parameters
    key_params = [
        "车型名称",
        "厂商指导价(元)",
        "厂商",
        "级别",
        "能源类型",
        "环保标准",
        "上市时间",
        "最大功率(kW)",
        "最大扭矩(N·m)",
        "变速箱",
        "车身结构",
        "发动机",
        "长*宽*高(mm)",
        "官方0-100km/h加速(s)",
        "最高车速(km/h)",
        "WLTC综合油耗(L/100km)",
        "整车质保",
        "整备质量(kg)",
        "最大满载质量(kg)",
    ]
    params = cars_data["result"]["titlelist"]

    # 遍历这个数组 获取['items']下的['itemname']
    # 只保留需要的参数
    params = [par for par in params if "items" in par]
    key_params = []
    for i, p in enumerate(params):
        if "items" in p:
            for item in p["items"]:
                if "itemname" in item:
                    key_params.append(item["itemname"])
        # print(f"param[{i}] keys: {p.keys()}")
    # Filter the parameters to include only the key parameters
    print(f"key_params: {len(key_params)}")
    # ['车型名称', '厂商指导价(元)', '经销商报价', '厂商', '级别', '能源类型', '环保标准', '上市时间', '最大功率(kW)', '最大扭矩(N·m)', '变速箱', '车身结构', '发动机', '长*宽*高(mm)', '官方0-100km/h加速(s)', '最高车速(km/h)', 'WLTC综合油耗(L/100km)', '整车质保', '整备质量(kg)', '最大满载质量(kg)', '长度(mm)', '宽度(mm)', '高度(mm)', '轴距(mm)', '前轮距(mm)', '后轮距(mm)', '接近角(°)', '离去角(°)', '车身结构', '车门开启方式', '车门数(个)', '座位数(个)', '油箱容积(L)', '后备厢容积(L)', '风阻系数(Cd)', '发动机型号', '排量(mL)', '排量(L)', '进气形式', '发动机布局', '气缸排列形式', '气缸数(个)', '每缸气门数(个)', '配气机构', '最大马力(Ps)', '最大功率(kW)', '最大功率转速(rpm)', '最大扭矩(N·m)', '最大扭矩转速(rpm)', '最大净功率(kW)', '能源类型', '燃油标号', '供油方式', '缸盖材料', '缸体材料', '环保标准', '简称', '挡位个数', '变速箱类型', '驱动方式', '前悬架类型', '后悬架类型', '助力类型', '车体结构', '前制动器类型', '后制动器类型', '驻车制动类型', '前轮胎规格', '后轮胎规格', '备胎规格', '主/副驾驶座安全气囊', '前/后排侧气囊', '前/后排头部气囊(气帘)', '被动行人保护', '缺气保用轮胎', 'ABS防抱死', '制动力分配(EBD/CBC等)', '刹车辅助(EBA/BAS/BA等)', '牵引力控制(ASR/TCS/TRC等)', '车身稳定控制(ESC/ESP/DSC等)', '胎压监测功能', '安全带未系提醒', 'ISOFIX儿童座椅接口', '车道偏离预警系统', '主动刹车/主动安全系统', '疲劳驾驶提示', '前方碰撞预警', '内置行车记录仪', '道路救援呼叫', '驾驶模式切换', '发动机启停技术', '自动驻车', '上坡辅助', '前/后驻车雷达', '驾驶辅助影像', '前方感知摄像头', '摄像头数量', '超声波雷达数量', '毫米波雷达数量', '巡航系统', '辅助驾驶等级', '倒车车侧预警系统', '卫星导航系统', '导航路况信息显示', '并线辅助', '车道保持辅助系统', '车道居中保持', '道路交通标识识别', '辅助泊车入位', '循迹倒车', '辅助变道', '外观套件', '轮圈材质', '电动后备厢', '感应后备厢', '发动机电子防盗', '车内中控锁', '钥匙类型', '无钥匙启动系统', '无钥匙进入功能', '主动闭合式进气格栅', '远程启动功能', '近光灯光源', '远光灯光源', 'LED日间行车灯', '自适应远近光', '自动头灯', '转向头灯', '车前雾灯', '大灯高度可调', '大灯延时关闭', '天窗类型', '前/后电动车窗', '车窗一键升降功能', '车窗防夹手功能', '车内化妆镜', '后雨刷', '感应雨刷功能', '外后视镜功能', '中控彩色屏幕', '中控屏幕尺寸', '蓝牙/车载电话', '手机互联/映射', '语音识别控制系统', '车载智能系统', '车机智能芯片', '车联网', '4G/5G网络', 'OTA升级', 'Wi-Fi热点', '手机APP远程功能', '方向盘材质', '方向盘位置调节', '换挡形式', '多功能方向盘', '方向盘换挡拨片', '方向盘加热', '方向盘记忆', '行车电脑显示屏幕', '全液晶仪表盘', '液晶仪表尺寸', 'HUD抬头数字显示', '内后视镜功能', 'ETC装置', '多媒体/充电接口', 'USB/Type-C接口数量', '手机无线充电功能', '座椅材质', '主座椅调节方式', '副座椅调节方式', '主/副驾驶座电动调节', '前排座椅功能', '电动座椅记忆功能', '副驾驶位后排可调节按钮', '第二排座椅调节', '后排座椅放倒形式', '前/后中央扶手', '后排杯架', '扬声器品牌名称', '扬声器数量', '车内环境氛围灯', '空调温度控制方式', '后排独立空调', '后座出风口', '温度分区控制', '车载空气净化器', '车内PM2.5过滤装置', '外观颜色', '内饰颜色', '娱乐套装1', '娱乐套装2']
    # 车型数据
    carValues = cars_data["result"]["datalist"]
    carsData = []
    for carValue in carValues:

        cars = []
        paramconflists = carValue["paramconflist"]
        for paramconflist in paramconflists:
            cars.append(paramconflist["itemname"])
        carsData.append(cars)
        # print(f"cars : { len(cars)}")

    filtered_params = {k: param_dict.get(k, "") for k in key_params}
    for i, v in enumerate(key_params):
        filtered_params[v] = [car[i] for car in carsData]
        
    filtered_params["车型名称"] = spec_name  # Add the car model name
    data.append(filtered_params)


# Create a DataFrame from the data
df = pd.DataFrame(data)

# Display the DataFrame
# Display the first few rows and columns of the DataFrame
print(df.iloc[:, :10].head(10))  # 显式打印前10行和前10列
# print("DataFrame created successfully with shape:", df)
