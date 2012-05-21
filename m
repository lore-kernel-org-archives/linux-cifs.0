From: <Scott_Purcell@Dell.com>
Subject: Re: Trouble with mount.cifs while smbclient works (Ubuntu
 12.04)
Date: Mon, 21 May 2012 10:32:20 -0500
Message-ID: <B284DF0EE72EBA488F6C7ED035128BF5105B607D14@AUSX7MCPS302.AMER.DELL.COM>
References: <B284DF0EE72EBA488F6C7ED035128BF5105B547675@AUSX7MCPS302.AMER.DELL.COM>
	<CADT32e+HONu1ABEyjbgeLQjEBCzMjc01FTewJoHsT1bWn7tkTg@mail.gmail.com>
	<B284DF0EE72EBA488F6C7ED035128BF5105B4F777B@AUSX7MCPS302.AMER.DELL.COM>
	<201205180302.45016.linux@kukkukk.com>
	<B284DF0EE72EBA488F6C7ED035128BF5105B5B1C37@AUSX7MCPS302.AMER.DELL.COM>
	<20120519083749.513816b0@tlielax.poochiereds.net>
	<B284DF0EE72EBA488F6C7ED035128BF5105B4F777F@AUSX7MCPS302.AMER.DELL.COM>
	<CAH2r5msirj=AYseNMp7YFuCCYzv42ruLfDa-Ac0+DGg5yDt3WQ@mail.gmail.com>
	<B284DF0EE72EBA488F6C7ED035128BF5105B4F7780@AUSX7MCPS302.AMER.DELL.COM>
	<CAH2r5mtG2=A66Kp3NJUH5kXnH9h8dTpAGn0-6YToppA9zN-Gbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: samba@lists.samba.org, linux-cifs@vger.kernel.org
To: <smfrench@gmail.com>
Return-path: <samba-bounces@lists.samba.org>
In-Reply-To: <CAH2r5mtG2=A66Kp3NJUH5kXnH9h8dTpAGn0-6YToppA9zN-Gbw@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba>,
	<mailto:samba-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba>
List-Post: <mailto:samba@lists.samba.org>
List-Help: <mailto:samba-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba>,
	<mailto:samba-request@lists.samba.org?subject=subscribe>
Sender: samba-bounces@lists.samba.org
Errors-To: samba-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Submitted as bug 8950.

-----Original Message-----
From: Steve French [mailto:smfrench@gmail.com] =

Sent: Saturday, May 19, 2012 6:47 PM
To: Purcell, Scott
Cc: jlayton@samba.org; linux@kukkukk.com; samba@lists.samba.org; linux-cifs=
@vger.kernel.org
Subject: Re: [Samba] Trouble with mount.cifs while smbclient works (Ubuntu =
12.04)

Don't want to forget is to open a bug report (at bugzilla.samba.org)
if you haven't already created one - even if tricky to fix safely, I
don't want to lose track of this issue if we can find a way to safely
handle this case.   There is a lot going on in development of cifs.ko
with smb2 enablement and the introduction of "SMB 3" (and also some
dramatic performance improvements that went in over the last four
releases).

On Sat, May 19, 2012 at 6:20 PM,  <Scott_Purcell@dell.com> wrote:
> I'll inquire. =A0But we're a very windows-centric shop -- I may be given =
the old "Working as designed... if it won't work on Linux you'll have to us=
e Windows" routine...
>
> Scott Purcell
> Content Development: Linux, Virtualization, and Cloud Solutions
> Dell | GSD Learning & Development
> ________________________________________
> From: Steve French [smfrench@gmail.com]
> Sent: Saturday, May 19, 2012 10:25 AM
> To: Purcell, Scott
> Cc: jlayton@samba.org; linux@kukkukk.com; samba@lists.samba.org; linux-ci=
fs@vger.kernel.org
> Subject: Re: [Samba] Trouble with mount.cifs while smbclient works (Ubunt=
u 12.04)
>
> On Sat, May 19, 2012 at 9:52 AM, =A0<Scott_Purcell@dell.com> wrote:
>> Is there any workaround?
>
> Fixing the permissions on the parent directory so it can be traversed
> is not possible?
>> ________________________________________
>> From: Jeff Layton [jlayton@poochiereds.net] On Behalf Of Jeff Layton [jl=
ayton@samba.org]
>> Sent: Saturday, May 19, 2012 7:37 AM
>> To: Purcell, Scott
>> Cc: linux@kukkukk.com; samba@lists.samba.org; linux-cifs@vger.kernel.org
>> Subject: Re: [Samba] Trouble with mount.cifs while smbclient works (Ubun=
tu 12.04)
>>
>> On Fri, 18 May 2012 16:32:29 -0500
>> <Scott_Purcell@Dell.com> wrote:
>>
>>> Yes, I think that has been the normal behavior since our data was moved=
 to this device. =A0I assumed it was due to filesystem permissions -- that =
I don't have read access to the root level of the share, but do have r/w ac=
cess to the /training/ directory below it.
>>>
>>> Using smbclient, get "NT_STATUS_ACCESS_DENIED" when I try:
>>>
>>> =A0 =A0 =A0 ls
>>> =A0 =A0 =A0 ls training
>>> =A0 =A0 =A0 ls /training
>>> =A0 =A0 =A0 ls /training/
>>>
>>> but if I cd to training, I can list its contents.
>>>
>>> BTW,
>>>
>>> I've tried appending the path in my mount command as well and mount.cif=
s still doesn't handle it:
>>>
>>>
>>
>> Known problem since the superblock sharing patches went in. cifs.ko
>> needs to establish a dentry and inode for the root of the share and
>> then walks down to the "prefixpath" for the mount. Unfortunately if you
>> don't have access to any point along that path, the mount will fail.
>>
>> There have been a couple of proposals to fix it, but they've had their
>> own problems. What probably needs to happen is to do something like
>> what NFS does in its superblock sharing model. Allow several trees of
>> dentries within a superblock and only connect them later if we happen
>> to stumble across the right entry. See commit 54ceac45159 for an
>> explanation of the model NFS uses for this.
>>
>> --
>> Jeff Layton <jlayton@samba.org>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Thanks,
>
> Steve



-- =

Thanks,

Steve
-- =

To unsubscribe from this list go to the following URL and read the
instructions:  https://lists.samba.org/mailman/options/samba
