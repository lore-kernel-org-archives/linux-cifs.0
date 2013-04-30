From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: multiuser kerberised cifs via autofs needs root ticket cache
Date: Tue, 30 Apr 2013 17:59:36 +0200
Message-ID: <517FEA68.1060602@steve-ss.com>
References: <51723F74.3010807@steve-ss.com> <20130426101410.1754c9ab@tlielax.poochiereds.net> <517B0C3A.80809@steve-ss.com> <20130430092212.53254831@tlielax.poochiereds.net> <517FD018.40106@med.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Parzer <peter.parzer-A1rZ2h3LdSKdPOQpRHQ53DeJuz7u0hKX@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <517FD018.40106-A1rZ2h3LdSKdPOQpRHQ53DeJuz7u0hKX@public.gmane.org>
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
Hi Peter
I'm a fellow struggler but I think I can answer this one. I just tested 
it. You can choose anyone to be root. You can choose any key you happen 
to have around in the keytab. We use the machine key because its 
produced when you join the domain. If you didn't secify kerberos metod = 
xxx before you joined, you can create the keys using net ads keytab 
create -UAdminUser The, on boot run:
kinit -k MACHINE$
on boot and put the same command in a file under /etc/cron.hourly to 
keep it alive.

I don't think this is the correct way, but hey it works.
