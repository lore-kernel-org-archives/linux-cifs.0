From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/8] cifs: Fix xattr name checks
Date: Wed, 13 Apr 2016 23:49:02 -0500
Message-ID: <CAH2r5mvsOcRrNVr=4fuf2zFEeKYSHDvxhZ1nhD1u0pLiQ9LARA@mail.gmail.com>
References: <20160413182026.GR25498@ZenIV.linux.org.uk> <1460586620-5717-1-git-send-email-agruenba@redhat.com>
 <1460586620-5717-2-git-send-email-agruenba@redhat.com> <CAH2r5mumJ22+Q0bASFcXp5fK39Ubh+sznfOpVUtSJ94_c5gkxA@mail.gmail.com>
 <20160414043718.GS25498@ZenIV.linux.org.uk> <CAH2r5ms6USEO3a_EPUpgsnvTZgSHB2QqJnUnCSCQdFmvV0yPDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5ms6USEO3a_EPUpgsnvTZgSHB2QqJnUnCSCQdFmvV0yPDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If you prefer merging those out of your tree, you can add my
Reviewed-by if needed (for the three cifs patches)

On Wed, Apr 13, 2016 at 11:43 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> If you are planning to merge it in next few weeks (they fix bugs, and
> are safe so why not),  I can simply just back out my changes from
> cifs-2.6.git for-next branch and let you merge the trivial checkpatch
> cleanup attached.
>
> On Wed, Apr 13, 2016 at 11:37 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
>> On Wed, Apr 13, 2016 at 11:26:24PM -0500, Steve French wrote:
>>> Thanks for spotting this - merged into cifs-2.6.git.   checkpatch
>>> spotted and old indentation issue so I cleaned that up in a followon
>>> patch that I will send.
>>
>> *ugh*
>>
>> And in the meanwhile I'd picked those into my queue...  Could you put that
>> stuff on a separate branch so that both cifs-2.6.git and vfs.git could
>> merge it?
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
