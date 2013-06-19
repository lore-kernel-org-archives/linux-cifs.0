From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: cifs.upcall -c documentation confusion
Date: Tue, 18 Jun 2013 21:12:14 -0400
Message-ID: <20130618211214.58c7aace@tlielax.poochiereds.net>
References: <1371222619.1722.21.camel@hh16.hh3.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1371222619.1722.21.camel-HkULYb+WTT7YCGPCin2YbQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 14 Jun 2013 17:10:19 +0200
steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:

> openSUSE 12.3, samba 4.0 DC, cifs-utils 6.0
> 
> Hi
> openSUSE and Ubuntu come with this line as default
> in /etc/request-key.conf
> create cifs.spnego * *  /usr/sbin/cifs.upcall -c %k
> 
> man cifs.upcall gives:
> OPTIONS
> -c
> This option is deprecated and is currently ignored.
> 
> To get cifs.upcall to work, I must specify a key at mount time. This key
> has to be present in /etc/krb5.keytab.
> 
> Jeff Layton has just given me a patch which allows e.g.:
> create cifs.spnego * *  /usr/sbin/cifs.upcall -d /etc/cifs.keytab %k
> 
> 
> Question:
> What key does cifs.upcall look for if there is no username= parameter
> for mount.cifs?
> 

mount.cifs always passes a username to the kernel. If you don't specify
one, it determines it based on the user running the mount.cifs. Most
likely, it's passing in "username=root" in your case.

> Should I remove the -c? (nothing is mounted if it is present).
> 

It shouldn't matter either way. The "-c" option is ignored.

> syslog errors:
> cifs.upcall checks the cache's and if it finds none always gives:
> failed to obtain service ticket
> even though it just created a cache by looking in the keytab and did the
> mount
> Could the error be sent _after_ request-key.conf has been consulted?
> 

request-key.conf isn't consulted by the program itself. It tells
request-key which program to run and how to run it in order to handle a
keys API upcall.

handle_krb5_mech can get called multiple times if the initial attempts
to get a service ticket for a particular hostname fail. It's true that
that error gets logged on each attempt, but it's being logged at
LOG_DEBUG level. I'd be hesitant to remove it since those errors tell
you something if you're trying to track down problems in this code.

If you're concerned about those messages, then you may want to turn
down the daemon facility loglevel in syslog.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
