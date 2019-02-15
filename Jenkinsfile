pipeline {
  agent {
    dockerfile {
      filename 'jenkinsFile'
    }

  }
  stages {
    stage('Checkout') {
      steps {
        git(url: 'https://github.com/bhoslepu/tfdemo.git', branch: 'master')
      }
    }
  }
}