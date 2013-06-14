From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: cifs.upcall -c documentation confusion
Date: Fri, 14 Jun 2013 17:10:19 +0200
Message-ID: <1371222619.1722.21.camel@hh16.hh3.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

openSUSE 12.3, samba 4.0 DC, cifs-utils 6.0

Hi
openSUSE and Ubuntu come with this line as default
in /etc/request-key.conf
create cifs.spnego * *  /usr/sbin/cifs.upcall -c %k

man cifs.upcall gives:
OPTIONS
-c
This option is deprecated and is currently ignored.

To get cifs.upcall to work, I must specify a key at mount time. This key
has to be present in /etc/krb5.keytab.

Jeff Layton has just given me a patch which allows e.g.:
create cifs.spnego * *  /usr/sbin/cifs.upcall -d /etc/cifs.keytab %k


Question:
What key does cifs.upcall look for if there is no username= parameter
for mount.cifs?

Should I remove the -c? (nothing is mounted if it is present).

syslog errors:
cifs.upcall checks the cache's and if it finds none always gives:
failed to obtain service ticket
even though it just created a cache by looking in the keytab and did the
mount
Could the error be sent _after_ request-key.conf has been consulted?

Thanks,
Steve
