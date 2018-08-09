<template>
  <b-modal v-model="modalShow" title="Modifica assegnazione ip" @ok="endEdit">
    <b-form v-if="ip" @submit.stop.prevent="endEdit">
      <b-form-group label="name">
        <b-form-input    type="text" v-model="ip.info.name" label="Name"></b-form-input>
      </b-form-group>
      <b-form-group label="comment" placeholder="Something about eva">
        <b-form-textarea type="text" v-model="ip.info.comment" label="Description"></b-form-textarea>
      </b-form-group>
    </b-form>
  </b-modal>
</template>

<script>
module.exports = {
  props: ['ip', 'modalShow'],
  data: function () {
    return {
    }
  },
  methods: {
    endEdit: function(e) {
      e.preventDefault();
      this.handleSubmit()
    },
    handleSubmit: function() {
      this.$emit('handleSubmit')
    },
  }
}
</script>

<style scoped>
</style>
