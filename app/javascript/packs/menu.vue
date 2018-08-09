<template>
<b-navbar toggleable="md" type="dark" variant="info">
  <b-nav-toggle target="nav_collapse"></b-nav-toggle>
  <b-navbar-brand :href="root_path">NmsOnRails</b-navbar-brand>
  <b-collapse is-nav id="nav_collapse">
    <b-nav is-nav-bar>
      <b-nav-item href="#">Link</b-nav-item>
      <b-nav-item href="#" disabled>Disabled</b-nav-item>
    </b-nav>
    <!-- Right aligned nav items -->
    <b-nav is-nav-bar class="ml-auto">
      <b-nav-form>
        <b-form-input size="sm" class="mr-sm-2" type="text" placeholder="Search"/>
        <b-button size="sm" class="my-2 my-sm-0" type="submit">Search</b-button>
      </b-nav-form>
      <b-nav-item-dropdown text="Lang" right>
        <b-dropdown-item href="#">EN</b-dropdown-item>
        <b-dropdown-item href="#">ES</b-dropdown-item>
        <b-dropdown-item href="#">RU</b-dropdown-item>
        <b-dropdown-item href="#">FA</b-dropdown-item>
      </b-nav-item-dropdown>
      <b-nav-item-dropdown right>
        <!-- Using button-content slot -->
        <template slot="button-content">
          <em>User</em>
        </template>
        <b-dropdown-item href="#">Profile</b-dropdown-item>
        <b-dropdown-item href="#">Signout</b-dropdown-item>
      </b-nav-item-dropdown>
    </b-nav>
  </b-collapse>
  <!-- <a href="https://github.com/donapieppo/nms-on-rails"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://camo.githubusercontent.com/e7bbb0521b397edbd5fe43e7f760759336b5e05f/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677265656e5f3030373230302e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_green_007200.png"></a> -->
</b-navbar>
</template>

<script>
export default {
  props: ['root_path', 'networks'],
  data: function () {
    return {
      test: 'test message'
    }
  }
}
</script>

<style scoped>
p {
}
</style>
