(function(context) {

	function Language(l) {
		this.language = l;
		this.stashed = {};
	};
	
	Language.prototype.generate = function() {
		return this.eval(":start");
	};
	
	Language.prototype.eval = function(part) {
	    if (part instanceof Array) {
			return this.eval(part[Math.floor(Math.random() * part.length)]);
		} else if (typeof part == 'function') {
			return part.apply(this);
		} else if (typeof part == 'string') {
			var self = this;
			return part.replace(/:(\w+)/g, function(matches) {
			    return self.eval(self.language[matches.substring(1)] || '');
			});
		}
	};

	Language.prototype.stash = function(key, value) {
		if (!(key in this.stashed)) {
			this.stashed[key] = value;
		}
		return this.stashed[key];
	};

	context.codshit = { Language: Language };

})(this);
