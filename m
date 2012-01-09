From: =?iso-8859-1?B?RnLpZOlyaWMgTC4gVy4=?= Meunier
	<fredlwm-fLz7/M+a0ZzR7s880joybQ@public.gmane.org>
Subject: cifs-utils: make fails if keyutils isn't installed
Date: Mon, 9 Jan 2012 14:00:15 -0200
Message-ID: <20120109160015.GB16818@pervalidus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I moved from cifs-utils 5.0 to 5.2. I didn't have keyutils installed and 
the compilation failed because configure checks for its presence, but 
doesn't abort if it's missing, and make tries to link to it.

...
checking keyutils.h usability... no
checking keyutils.h presence... no
checking for keyutils.h... no
configure: WARNING: keyutils.h not found, consider installing 
keyutils-libs-devel. Disabling cifs.upcall.
configure: WARNING: keyutils.h not found, consider installing 
keyutils-libs-devel. Disabling cifs.idmap.
...

Makefile.in:

@CONFIG_CIFSACL_TRUE@getcifsacl_LDADD = -lkeyutils $(WINB_LDADD)                
@CONFIG_CIFSACL_TRUE@setcifsacl_LDADD = -lkeyutils $(WINB_LDADD)

Apparently, getcifsacl and setcifsacl don't use keyutils at all, but 
cifs-utils links to it ?
