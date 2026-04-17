<template>
  <div class="main-container">
    <div class="left-panel">
      <div class="static-area">
        <div class="item-static" v-for="(item, index) in staticData" :key="index">
          <div class="count">{{ item.count }}</div>
          <div class="text">{{ item.name }}</div>
        </div>
      </div>

      <div class="chart-grid">
        <div class="chart-card">
          <LineChart
            height="360px"
            tag="领养订单创建趋势"
            subtext="订单数"
            :values="orderCountValues"
            :date="orderCountDates"
            :default-range="365"
            @time-change="fetchPetAdoptOrderCount"
          />
        </div>

        <div class="chart-card">
          <div class="chart-card-title">宠物类别分布</div>
          <PieCharts height="360px" :data="petTypeCountList" />
        </div>

        <div class="chart-card">
          <div class="chart-card-title">领养人性别分布</div>
          <PieCharts height="360px" :data="adopterGenderList" />
        </div>

        <div class="chart-card">
          <BarChart
            height="360px"
            tag="领养人年龄段分布"
            :values="adopterAgeValues"
            :date="adopterAgeLabels"
          />
        </div>

        <div class="chart-card">
          <LineChart
            height="360px"
            tag="平均领养耗时趋势"
            subtext="平均耗时(天)"
            :values="adoptDurationValues"
            :date="adoptDurationDates"
            :show-controls="false"
          />
        </div>

        <div class="chart-card">
          <BarChart
            height="360px"
            tag="宠物吸引力与领养率"
            :values="petAttractionValues"
            :date="petAttractionLabels"
          />
        </div>
      </div>
    </div>

    <div class="right-panel">
      <div class="section-title">宠物信息</div>
      <div v-for="(item, index) in petList" :key="index" class="pet-preview">
        <img class="pet-cover" :src="item.cover" alt="">
        <div class="pet-name" @click="viewPetDetail(item.id)">
          {{ item.name }}
        </div>
        <div class="pet-meta">{{ item.petTypeName }} · {{ item.address }}</div>
      </div>
    </div>
  </div>
</template>

<script>
import BarChart from '@/components/BarChart.vue';
import LineChart from '@/components/LineChart.vue';
import PieCharts from '@/components/PieCharts.vue';

export default {
  components: { PieCharts, BarChart, LineChart },
  data() {
    return {
      staticData: [],
      petTypeCountList: [],
      orderCountValues: [],
      orderCountDates: [],
      adopterGenderList: [],
      adopterAgeValues: [],
      adopterAgeLabels: [],
      adoptDurationValues: [],
      adoptDurationDates: [],
      petAttractionValues: [],
      petAttractionLabels: [],
      petList: []
    };
  },
  created() {
    this.fetchStatic();
    this.fetchPetTypeCount();
    this.fetchPetAdoptOrderCount(365);
    this.fetchAdopterGenderDistribution();
    this.fetchAdopterAgeDistribution();
    this.fetchAdoptDurationTrend();
    this.fetchPetAttractionAdoptionRate();
    this.fetchPetData();
  },
  methods: {
    viewPetDetail(id) {
      window.open(`pet-detail-admin?id=${id}`, '_blank');
    },
    async fetchPetData() {
      try {
        const petQueryDto = {
          size: 4,
          current: 1
        };
        const { data } = await this.$axios.post('/pet/list', petQueryDto);
        this.petList = data;
      } catch (e) {
        console.log('首页宠物信息异常：', e);
      }
    },
    async fetchPetAdoptOrderCount(days) {
      try {
        const { data } = await this.$axios.get(`/main/petAdoptOrderCount/${days}`);
        this.orderCountValues = data.map(entity => entity.count);
        this.orderCountDates = data.map(entity => entity.name);
      } catch (e) {
        console.log('首页领养订单趋势异常：', e);
      }
    },
    async fetchPetTypeCount() {
      try {
        const { data } = await this.$axios.get('/main/petTypeCount');
        this.petTypeCountList = data.map(entity => ({
          name: entity.name,
          value: entity.count
        }));
      } catch (e) {
        console.log('首页宠物类别统计异常：', e);
      }
    },
    async fetchAdopterGenderDistribution() {
      try {
        const { data } = await this.$axios.get('/main/adopterGenderDistribution');
        this.adopterGenderList = data.map(entity => ({
          name: entity.name,
          value: entity.count
        }));
      } catch (e) {
        console.log('首页领养人性别统计异常：', e);
      }
    },
    async fetchAdopterAgeDistribution() {
      try {
        const { data } = await this.$axios.get('/main/adopterAgeDistribution');
        this.adopterAgeValues = data.map(entity => entity.count);
        this.adopterAgeLabels = data.map(entity => entity.name);
      } catch (e) {
        console.log('首页领养人年龄统计异常：', e);
      }
    },
    async fetchAdoptDurationTrend() {
      try {
        const { data } = await this.$axios.get('/main/adoptDurationTrend');
        this.adoptDurationValues = data.map(entity => entity.count);
        this.adoptDurationDates = data.map(entity => entity.name);
      } catch (e) {
        console.log('首页领养耗时趋势异常：', e);
      }
    },
    async fetchPetAttractionAdoptionRate() {
      try {
        const { data } = await this.$axios.get('/main/petAttractionAdoptionRate');
        this.petAttractionValues = data.map(entity => entity.count);
        this.petAttractionLabels = data.map(entity => entity.name);
      } catch (e) {
        console.log('首页宠物吸引力统计异常：', e);
      }
    },
    async fetchStatic() {
      try {
        const { data } = await this.$axios.get('/main/staticData');
        this.staticData = data;
      } catch (e) {
        console.log('首页静态数据异常：', e);
      }
    }
  }
};
</script>

<style scoped lang="scss">
.main-container {
  margin: 0 24px 24px;
  box-sizing: border-box;
  display: flex;
  gap: 20px;
  overflow-x: hidden;
}

.left-panel {
  width: calc(100% - 280px);
}

.static-area {
  background-color: rgb(248, 248, 248);
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 12px;
  padding: 14px;
  border-radius: 12px;
  margin-bottom: 20px;
}

.item-static {
  background: #fff;
  border-radius: 10px;
  padding: 12px 10px;
  box-shadow: 0 8px 20px rgba(15, 23, 42, 0.05);
}

.count {
  text-align: center;
  padding-block: 8px;
  font-size: 24px;
  font-weight: 800;
}

.text {
  font-size: 14px;
  text-align: center;
  color: #4b5563;
}

.chart-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 18px;
}

.chart-card {
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 12px 28px rgba(15, 23, 42, 0.06);
  padding: 8px;
}

.chart-card-title {
  padding: 12px 16px 0;
  font-size: 24px;
  font-weight: 600;
}

.right-panel {
  width: 260px;
  padding: 14px;
  border-radius: 14px;
  background: #fff;
  box-shadow: 0 12px 28px rgba(15, 23, 42, 0.06);
  align-self: flex-start;
}

.section-title {
  margin-bottom: 18px;
  font-size: 22px;
  font-weight: 700;
}

.pet-preview {
  margin-bottom: 18px;
}

.pet-cover {
  width: 100%;
  height: 128px;
  border-radius: 10px;
  object-fit: cover;
}

.pet-name {
  margin: 10px 0 6px;
  font-size: 18px;
  font-weight: 600;
  cursor: pointer;
  line-height: 1.4;
}

.pet-meta {
  font-size: 13px;
  color: #6b7280;
  line-height: 1.5;
}
</style>
