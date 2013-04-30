From: "Robert J. Hendelman Jr" <rob-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Subject: Re: multiuser kerberised cifs via autofs needs root ticket cache
Date: Tue, 30 Apr 2013 11:08:24 -0500 (CDT)
Message-ID: <130544162.20927.1367338104929.JavaMail.root@hendelman.net>
References: <517FEA68.1060602@steve-ss.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Peter Parzer <peter.parzer-A1rZ2h3LdSKdPOQpRHQ53DeJuz7u0hKX@public.gmane.org>
To: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <517FEA68.1060602-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 30/04/13 16:07, Peter Parzer wrote:
> Hi,
>
> Am 30.04.2013 15:22, schrieb Jeff Layton:
>>
>> No, that's not what I'm saying at all. You can get the same effect by
>> setting up credentials for root in /etc/krb5.keytab. Just pass in the
>> correct username= mount option for the principal that you want root to
>> be.
>>

>
> Not exactly on the topic, but I have been struggling a long time with 
> this question. How can I setup credentials for root in 
> /etc/krb5.keytab? I do the cifs multiuser mount in /etc/fstab at boot 
> time. To create Kerberos tickets for root I have a network if-up hook 
> with the command "net ads kerberos kinit -P". Is there an easier way 
> using the keytab file?
>


I was originally trying to do something similar.  

See https://bugs.launchpad.net/ubuntu/+source/upstart/+bug/1130781 for my Ubuntu bug report for more info.

The bug report probably doesn't concern you, but I do have a working fstab line & pointers to a discussion about this earlier.

When I log into my (XFCE) desktop (twice - probably a bug), I have my ticket created and accessing files in my homedir (smb mounted) works just fine.

Hope this helps!

Best regards,

Robert
