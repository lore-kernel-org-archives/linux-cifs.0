From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: multiuser kerberised cifs via autofs needs root ticket cache
Date: Sat, 20 Apr 2013 09:10:44 +0200
Message-ID: <51723F74.3010807@steve-ss.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi
one of my automount files is:
* -fstype=cifs,sec=krb5,multiuser ://doloresdc/users/&

It works fine but only if the krb5cc_0 cache is available under /tmp. 
When a user logs in, he gets his own cache. With multiuser, why isn't 
that good enough to be able to mount his share?

Question, if we really must have the root cache then how do I get that 
on boot? I need to run this as root:
kinit -k steve2 to get the cache with my key in /etc/krb5.keytab. I 
can't find a way to be able to do that on either Ubuntu 12.10 nor 
openSUSE 12.3.

There must be an easy way.
Cheers,
Steve
