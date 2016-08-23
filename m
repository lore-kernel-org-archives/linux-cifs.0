From: Stanislav Brabec <sbrabec-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: nfs/cifs mountinfo differences
Date: Tue, 23 Aug 2016 19:23:33 +0200
Message-ID: <c4f10081-4525-4ac0-0e6b-b364c7268200@suse.cz>
References: <91d465d3-4f5b-6270-a6c5-38bd94695731@suse.cz>
 <5eb96b3e-d463-bf11-49de-f614247d6b29@suse.cz>
 <20160805192234.2c9d5b7d@aaptelpc>
 <7c2181d1-c7b5-df04-0640-ec23f5d78eab@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: util-linux <util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7c2181d1-c7b5-df04-0640-ec23f5d78eab-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Aug 16, 2016 at 07:44 PM Stanislav Brabec wrote:
> Aurélien Aptel wrote on Aug 5, 2016 at 7:22 PM:
>> We can't we compare in this case? Isn't it just a matter of
>> concatenating the source with the subdir?
>
> Well, it looks possible. The path component 1 is always the server name,
> 2 volume name, and the rest is path.
>
> So cut components 3 and up, and remove it from the leading part of 4th
> column. Then you will have a part that can be used for bind mount
> processing.
>
I did a new patch that searches the subdir part of the source and cuts
it out from root for purpose of root comparison.

Please review the algorithm of searching of the subdir component in the
source string in the reply to this mail.

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
