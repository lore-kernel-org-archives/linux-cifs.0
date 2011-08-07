From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: new sparse warning fs/cifs/cifsfs.c:168:15: warning: dereference
 of noderef expression fs/cifs/cifsfs.c:542:15: warning: dereference of
 noderef expression
Date: Sun, 7 Aug 2011 14:32:26 -0500
Message-ID: <CAH2r5mvxRfrAUA9kXwCojg_0_YTC=W623A-tqERBkeWL5pvf6g@mail.gmail.com>
References: <CAH2r5mszsiu2Gm-DPbfT8UReT=eBTf4Du4eyEapG8Ayn7UN1pw@mail.gmail.com>
	<20110807174829.GY2203@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110807174829.GY2203-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Aug 7, 2011 at 12:48 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrot=
e:
> On Sun, Aug 07, 2011 at 11:22:51AM -0500, Steve French wrote:
>> I noticed a series of sparse warnings (on all calls to cifs's GetXid
>> after building on a newly install fc15 system (yum installed a spars=
e
>> binary dated June 23).
>>
>> fs/cifs/cifsfs.c:168:15: warning: dereference of noderef expression
>> fs/cifs/cifsfs.c:542:15: warning: dereference of noderef expression
>>
>> Has sparse changed to add a new warning - I see (from quick search)
>> others getting this on other modules years ago, but I didn't see
>> anything obvious wrong with the definition of the function, and I
>> hadn't noticed sparse complaining about it before, and would like to
>> remove the 50+ new messages as they clutter the build output.
>
> It's not sparse change - the whinge comes from current_fsuid(), i.e. =
direct
> read of current->cred, even though it's declared with __rcu. =A0The t=
hing is,
> current->cred does *not* need rcu_dereference() - only the task itsel=
f
> can change it. =A0Easily fixed...

your change makes sense - thx


Steve
