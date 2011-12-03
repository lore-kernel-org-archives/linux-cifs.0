From: jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: problem mounting under Xubuntu
Date: Sat, 03 Dec 2011 05:45:37 +0000
Message-ID: <jbcd21$6oh$1@dough.gmane.org>
References: <4ED3017A.9030502@gmail.com> <20111128153207.163adbfe@tlielax.poochiereds.net> <CADT32eJmg1FCvyoksCssjwGQmR75xMdRW_zSdP5z+V6hQSbqsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJmg1FCvyoksCssjwGQmR75xMdRW_zSdP5z+V6hQSbqsQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 02/12/11 15:39, Shirish Pargaonkar wrote:
>
> Looked at the wireshark traces.
>
> Jeff is right. Tree connect is denied for    anonymous   user.
> Tree connect to IPC$ share succeeds subsequently.
>
> You are authenticating as user jr when using smbclient but as user
> anonymous when using cifs client.  I think that makes a difference
> during tree connect.

unfortunately, mount.cifs //nas/public /mnt -o username=jr  does not 
work either (same error 13).

also, the anonymous access to the NAS does work fine from a slackware 
machine (which uses v 1.48).

do you have any (other) suggestions?  again, thanks for your time.
