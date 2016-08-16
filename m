From: Stanislav Brabec <sbrabec-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: nfs/cifs mountinfo differences
Date: Tue, 16 Aug 2016 19:44:47 +0200
Message-ID: <7c2181d1-c7b5-df04-0640-ec23f5d78eab@suse.cz>
References: <91d465d3-4f5b-6270-a6c5-38bd94695731@suse.cz>
 <5eb96b3e-d463-bf11-49de-f614247d6b29@suse.cz>
 <20160805192234.2c9d5b7d@aaptelpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: util-linux <util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160805192234.2c9d5b7d@aaptelpc>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Aurélien Aptel wrote on Aug 5, 2016 at 7:22 PM:
> Now correct me if I'm wrong (I really am not sure) but I think 'mount
> -a' assumes only bind-mounts should print a subdir path instead of "/".

Yes. It is the only indication that the mountinfo line describes a bind 
mount.

> or (B) we consider the current kernel doc as the Truth:
>
> - we make NFS do like CIFS
> - leave CIFS unchanged [1]
> - figure out what to do with mount utility (back to initial problem I
>   guess)

The proposed patch does the thing.

> Personal opinion: the way the current doc is written and again, the fact
> that linux lets you override the path on a per-filesystem basis makes me
> think solution B is the way to go.
>
> Also, I don't understand why
>
>
> We can't we compare in this case? Isn't it just a matter of
> concatenating the source with the subdir?

Well, it looks possible. The path component 1 is always the server name, 
2 volume name, and the rest is path.

So cut components 3 and up, and remove it from the leading part of 4th 
column. Then you will have a part that can be used for bind mount 
processing.

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                         e-mail: sbrabec-IBi9RG/b67k@public.gmane.org
Křižíkova 148/34 (Corso IIa)                  tel: +49 911 7405384547
186 00 Praha 8-Karlín                          fax:  +420 284 084 001
Czech Republic                                    http://www.suse.cz/
PGP: 830B 40D5 9E05 35D8 5E27 6FA3 717C 209F A04F CD76
