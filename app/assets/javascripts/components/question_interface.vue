<style lang="scss">
  $background-color: #EFF4F9;
  $medium-color: #797A9E;
  $dark-color: #625F63;
  $border-color: rgba(121, 122, 158, 0.50);
  $font-stack: 'Helvetica Neue', Helvetica, Arial, sans-serif;

  .question-interface {
    h1 {
      font-family: $font-stack;
      font-size: 18pt;
      font-weight: 300pt;
      text-align: center;
      color: $medium-color;
    }

    h2 {
      font-family: $font-stack;
      font-size: 10pt;
      font-weight: 300;
      line-height: 18px;
      letter-spacing: 0.3px;
      color: $medium-color;
      margin-bottom: 15px;
    }

    .prompt-author {
      font-weight: 500;
      margin-bottom: 0px;
    }

    textarea {
      width: 100%;
      height: 70vh;
      border-color: $dark-color;
      border-style: solid;
      border-width: 1px;
      border-radius: 2px;
      font-family: $font-stack;
      font-size: 10pt;
      font-weight: 300;
      line-height: 18px;
      letter-spacing: 0.3px;
      color: $dark-color;
    }

    button {
      border: none;
      background-color: $medium-color;
      color: $background-color;
      min-width: 60px;
      padding-left: 8px;
      padding-right: 8px;
      margin-top: 8px;
      margin-bottom: 2px;
      margin-left: 3px;
      margin-right: 3px;
    }

    .entry {
      border-bottom-style: solid;
      border-width: 1px;
      border-color: $border-color;
      padding-top: 25px;
      padding-bottom: 2px;
      padding-left: 16px;
      color: $dark-color;
      font-family: $font-stack;
      font-size: 10pt;
      font-weight: 300;
      line-height: 18px;
      letter-spacing: 0.3px;
    }

    .entry-other-author {
      border-left-style: solid;
      border-left-width: 6px;
      border-left-color: $border-color;
      padding-left: 10px;
    }

    .first-entry {
      padding-top: 0px;
    }

    .entry-metadata {
      color: $medium-color;
      font-size: 8pt;
      font-family: $font-stack;
      text-transform: uppercase;
      padding-top: 10px;
    }
  }
</style>

<template>
  <section class="question-interface">
    <div class="row">
      <h1>{{question}}</h1>
    </div>
    <div class="row">
      <div class="one-half column">
        <textarea v-model="newEntry" placeholder="Write your thoughts here. Aim to write a few paragraphs!"></textarea>
        <button v-on:click="publishEntry">Publish</button>
      </div>
      <div class="one-half column">
        <div class="entry" v-for="entry in entries" v-bind:class="{'first-entry' : $index == 0, 'entry-other-author' : entry.author != currentUser}">
          <div v-html="entry.text | marked">  </div>
          <div class="entry-metadata">
            {{entry.author}} | {{entry.created_time}}
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script lang="coffee">
  Vue = require 'vue'
  Vue.use(require('vue-resource'))
  Vue.http.headers.common['X-CSRF-TOKEN'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  Marked = require 'marked'

  entries = []

  module.exports =
    data: ->
      question: ''
      newEntry: ''
      entries: []
    filters:
      marked: Marked
    props: ['currentUser']
    methods:
      refreshStudentQuestion: ->
        @$http.get("student_questions/#{@$route.params.student_question_id}").then((response) ->
          @$set 'question', response.data.student_question.question_text
        )
      refreshEntries: ->
        @$http.get("student_questions/#{@$route.params.student_question_id}/entries").then((response) ->
          @$set 'entries', response.data.student_questions
        )
      publishEntry: ->
        entryText = @newEntry.trim()
        if entryText
          data =
            student_question_id: 1
            text: entryText
          @$http.post("student_questions/#{@$route.params.student_question_id}/new_entry", data)
          @refreshEntries()
          @newEntry = ''

    ready: ->
      @refreshStudentQuestion()
      @refreshEntries()
</script>
