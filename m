From: Mark Moseley <moseleymark@gmail.com>
Subject: Re: CIFS Unmount Issue
Date: Mon, 6 Feb 2012 17:02:08 -0800
Message-ID: <CAOH1cHkyMY8LQzfpJZPwqZeB+wa+CNW8bGi7DGiKN7WmKsiAig@mail.gmail.com>
References: <CAOH1cH=WsgDhwz1Dp5UsU3KV5Ocb3My9W3yjfEXiftHhHQ36ig@mail.gmail.com>
	<20120205073231.0f245671@tlielax.poochiereds.net>
	<20120205161034.6aa790c4@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120205161034.6aa790c4@tlielax.poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sun, Feb 5, 2012 at 1:10 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Sun, 5 Feb 2012 07:32:31 -0500
> Jeff Layton <jlayton@redhat.com> wrote:
>
>> On Fri, 3 Feb 2012 15:47:08 -0800
>> Mark Moseley <moseleymark@gmail.com> wrote:
>>
>> > I've got a slew of Netapp Filers talking CIFS to some Debian Squee=
ze
>> > 64-bit boxes. I've noticed that in the kernel switch from 3.1 to 3=
=2E2,
>> > the clients are no longer able to unmount a CIFS volume from an ol=
der
>> > Filer. The Netapp versions in question are 7.2.7 and 7.0.6. I can
>> > unmount on a 3.2.x kernel from a 7.2.7 Filer just fine. With a 7.0=
=2E6
>> > Filer, I get the following error printed to /proc/kmsg:
>> >
>> > <3>[ =C2=A0277.363460] CIFS VFS: RFC1001 size 35 smaller than SMB =
for mid=3D12
>> > <7>[ =C2=A0277.363466] Bad SMB: : dump of 39 bytes of data at 0xff=
ff880213e7e000
>> > <7>[ =C2=A0277.363472] =C2=A023000000 424d53ff 00000074 00018800 .=
 . . # =EF=BF=BD S M B
>> > t . . . . . . .
>> > <7>[ =C2=A0277.363478] =C2=A000000000 00000000 00000000 0e1000....=
=2E...........<>
>> > 27338] 0c0000f0
>> >
>> > but the umount call never returns, which makes reboots fun. I've
>> > replicated this on 3.2.1 and 3.2.2. I've seen it print the same "B=
ad
>> > SMB..." message as pasted above with 3.1.10 but the umount call
>> > returns successfully. And unmounting from the 7.2.7 Filers does no=
t
>> > cause a "Bad SMB" message to get logged to /proc/kmsg.
>> >
>> > The client is still responsive, and I can run whatever would helpf=
ul
>> > to debug this. If I'm doing the unmount on the CLI, it hangs on th=
e
>> > 'umount' syscall. If I kill the umount command, the mount is gone.=
 As
>> > far as I can see, the unmount is succeeding, but for whatever reas=
on,
>> > the umount system call isn't ever returning. Looking at a network
>> > dump, the last client call is for a logoff, which seems to succeed=
=2E
>> >
>> > There are no oops's or tracebacks logged.
>> >
>> > I can post my whole .config if it's helpful, though for brevity sa=
ke,
>> > here's the CIFS section:
>> >
>> > CONFIG_CIFS=3Dm
>> > CONFIG_CIFS_STATS=3Dy
>> > # CONFIG_CIFS_STATS2 is not set
>> > CONFIG_CIFS_WEAK_PW_HASH=3Dy
>> > CONFIG_CIFS_UPCALL=3Dy
>> > CONFIG_CIFS_XATTR=3Dy
>> > CONFIG_CIFS_POSIX=3Dy
>> > # CONFIG_CIFS_DEBUG2 is not set
>> > CONFIG_CIFS_DFS_UPCALL=3Dy
>> > # CONFIG_CIFS_FSCACHE is not set
>> > # CONFIG_CIFS_ACL is not set
>> >
>> > Let me know what I can post to be of help here, or if I should rep=
ost
>> > to LKML, or if I should just dust off git bisect. Thanks!
>>
>> (cc'ing linux-cifs list too)
>>
>> NetApp filers have a long-standing (for years even) bug with their
>> handling of SMB_COM_LOGOFF_ANDX. The filer sends a malformed reply o=
n
>> that command. cifs.ko tends to be a little more strict on checking t=
he
>> various lengths in the packet than windows is so it tosses out the
>> reply.
>>
>> I'd suggest filing a bug with netapp on this. You can reference this
>> (ancient) RH bug if you need more ammo:
>>
>> =C2=A0 =C2=A0 https://bugzilla.redhat.com/show_bug.cgi?id=3D191112
>>
>> Now, that said...I think we have a bug in cifs.ko here too. It's
>> throwing out these replies without waking up the thread that's waiti=
ng
>> on it, even though we were probably able to match it to a request. T=
his
>> patch will probably fix it, but it's untested and I need to stare at=
 it
>> a bit more to ensure that it doesn't cause any problems.
>>
>> In the meantime if you have a machine where you could test this, tha=
t
>> would be helpful. I'll plan to send it to Steve F. for inclusion in =
3.3
>> and stable once I've smoke tested it a bit more.
>>
>> Thanks,
>
> Revised patch. We want to return "length" if the mid wasn't ID'ed:
>
> -------------------------------[snip]------------------------------
>
> cifs: don't return error from standard_receive3 after marking respons=
e malformed
>
> standard_receive3 will check the validity of the response from the
> server (via checkSMB). It'll pass the result of that check to handle_=
mid
> which will eventually dequeue it and mark it with a status of
> MID_RESPONSE_MALFORMED. At that point, it'll also return an error, wh=
ich
> will make the demultiplex thread skip doing the callback for the mid.
>
> This is wrong -- if we were able to identify the request and the
> response is now malformed, then we want the demultiplex thread to do =
the
> callback. =C2=A0Fix this by making standard_receive3 return 0 in this
> situation.
>
> Cc: stable@vger.kernel.org
> Reported-by: Mark Moseley <moseleymark@gmail.com>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
> =C2=A0fs/cifs/connect.c | =C2=A0 =C2=A07 ++++---
> =C2=A01 files changed, 4 insertions(+), 3 deletions(-)

Awesome, thanks for the info and thanks for the patch. I can confirm
it works just fine. The umount syscall comes back immediately and
everything looks good.

I'll see what Netapp says, though hopefully we'll be off of 7.0.6 soon =
anyway.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
