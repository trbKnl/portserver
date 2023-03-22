import { jsx as _jsx } from "react/jsx-runtime";
import Assembly from "port/dist/framework/assembly";
import { isCommandSystemDonate } from "port/dist/framework/types/commands";



// Webpack will make sure the assets below can be served from root
import "port/dist/port-0.0.0-py3-none-any.whl";
import "port/dist/styles.css";
//import "port/dist/framework/processing/py_worker.js";

export const Port = {
  mounted() {
    console.log("CREATING WORKER")
    const worker = new Worker(new URL("port/dist/framework/processing/py_worker.js", import.meta.url));
    const container = document.getElementById(this.el.id);
    console.log(`CONTAINER ID: ${container}`)
    const locale = this.el.dataset.locale;
    console.log(`LOCALE: ${locale}`)
    // const participant = this.el.dataset.participant;
    this.assembly = new Assembly(worker, this);
    this.assembly.visualisationEngine.start(container, locale);
    this.assembly.processingEngine.start();
  },

  destroyed() {
    //this.assembly.visualisationEngine.destroyed();
    console.log("DESTROYED");
  },

  send(command) {
    if (isCommandSystemDonate(command)) {
      this.handleDonation(command);
    } else {
      console.log(
        "[System] received unknown command: " + JSON.stringify(command)
      );
    }
  },

  handleDonation(command) {
    console.log(
      `[System] received donation: key=${command.key}, payload=${command.json_string}`
    );
    this.pushEvent("donate", command);
  },
};
