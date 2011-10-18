From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: async read patchset test results
Date: Tue, 18 Oct 2011 15:31:40 -0500
Message-ID: <CAH2r5muvh_6K_Ou4Jz3Qwu6GNRn9ZJwQ5wLw71g=OfZwj+HVNQ@mail.gmail.com>
References: <CAKywueS=dRdBzumxHc+QH1A3QhfTm7b8a2pM4w0pb6VXoi7aOQ@mail.gmail.com>
	<20111013083151.55aa1cdf@barsoom.rdu.redhat.com>
	<CAKywueQg90k2FwRB+fJbmwq230p-DP-Zxtrc0+HP_gfieHxM6g@mail.gmail.com>
	<20111013133414.77f54658@barsoom.rdu.redhat.com>
	<CAKywueTjAwgmSpYeqX-iu6FhZbCiG5HTztDhNLWYFMkq3cmoBg@mail.gmail.com>
	<CAH2r5msUKNYFMMyixLdnZ=BndxOp-ySrViYRhjkBpBDsQh_-aQ@mail.gmail.com>
	<20111013140039.3200de5d@barsoom.rdu.redhat.com>
	<CAKywueSfX7sn46uPTz2L3WWWZgpNmEfECJDv70Lr-jjFvTXi+g@mail.gmail.com>
	<CAKywueQ20Jh139J4E0XfJ+ZTPsO8gDpXPHL2jZ3YBh72ajKAWA@mail.gmail.com>
	<20111014065508.2f4735d3@tlielax.poochiereds.net>
	<CAKywueT3d0dEf__rsoFZ1VK3s72CLXJjFQyGqDdTEe=6-hH-Yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueT3d0dEf__rsoFZ1VK3s72CLXJjFQyGqDdTEe=6-hH-Yw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 18, 2011 at 3:29 PM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
> 2011/10/14 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> On Fri, 14 Oct 2011 14:02:54 +0400
>> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> Today, I caught it once again and didn't noticed any reconnects (no=
 cERRORs).
>>>
>>> It is surely not depends on Jeff's async read patchset, because I u=
sed
>>> my cifs-3.2-current branch.
>>>
>>> My branch consists of Steve's master + lockpatchset + smb2 patches.
>>> From another hand, previously I caught it with Jeff's branch (witho=
ut
>>> lockpatchset and smb2 patches). So, that's why the problem is in
>>> existing cifs code now.
>>>
>>> FYI: I checked two files: "buggy" and original, and noticed that th=
e
>>> difference between them is located in one place - positions from
>>> 2014442 to 2014569 - 126 differences with two equal holes.
>>>
>>> So, 2014569 - 2014442 + 1 =3D 128 wrong bytes. Ideas?
>>>
>>
>> Good to know, thanks. I also tried reproducing this for a while last
>> night and was unable to...
>>
>> I used this script:
>>
>> -------------------------[snip]------------------------------
>> #!/bin/bash
>>
>> origfile=3D$1
>> destfile=3D$2
>>
>> origsum=3D`md5sum $origfile | cut -d' ' -f1`
>> i=3D0
>>
>> while true; do
>> =A0 =A0 =A0 =A0echo $i
>> =A0 =A0 =A0 =A0rm -f $destfile $origfile.tmp
>>
>> =A0 =A0 =A0 =A0dd if=3D$origfile of=3D$destfile bs=3D100000
>> =A0 =A0 =A0 =A0if [ $? -ne 0 ]; then
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0echo "dd1 failed"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit 1
>> =A0 =A0 =A0 =A0fi
>>
>> =A0 =A0 =A0 =A0dd if=3D$destfile of=3D$origfile.tmp bs=3D100000
>> =A0 =A0 =A0 =A0if [ $? -ne 0 ]; then
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0echo "dd2 failed"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit 1
>> =A0 =A0 =A0 =A0fi
>>
>> =A0 =A0 =A0 =A0destsum=3D`md5sum $destfile | cut -d' ' -f1`
>
> As you have already read $destfile to $origfile.tmp, there is no need
> to read it again - you only need to calculate md5sum of the
> origfile.tmp.
>
>> =A0 =A0 =A0 =A0if [ "$origsum" !=3D "$destsum" ]; then
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0echo "md5sums don't match! orig=3D$or=
igsum dest=3D$destsum"
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stat $origfile
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stat $destfile
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit 1
>> =A0 =A0 =A0 =A0fi
>>
>> =A0 =A0 =A0 =A0i=3D`expr $i + 1`
>> done
>>
>> -------------------------[snip]------------------------------
>>
>> I ran the above with the first arg set to a ~615M .iso file on local
>> disk and the second to a file on a cifs mount.
>>
>> I ran it against my win2k8 host for several hours and it never faile=
d.
>> I then tried running it against my Windows 7 home host (running on
>> bare-metal) and it would run for a little while and would eventually
>> fail due to the server returning "out of memory" errors. Some of tho=
se
>> would occur on the NEGOTIATE call, so I chalk that up to a Win7 bug.
>>
>> I never saw this mismatch, but I think we can try to infer something
>> from the nature of the failures that Pavel saw...
>>
>> Since the file was apparently being written properly, the write phas=
e
>> seems like it worked correctly. The data all went into the cache, an=
d
>> then got flushed properly to the server.
>>
>> So, it seems likely that the problem is in the read phase of the tes=
t.
>> There are several possibilities:
>>
>> 1) we started out doing a cache read, but the cache was invalidated
>> partway through. "Something happened" and one of the reads got mangl=
ed.
>>
>> 2) the server sent us a corrupt read for some reason
>>
>> 3) lower level networking problem caused a corrupt read
>>
>> 4) generic memory corruption in the pagecache of some sort
>>
>> ...plus many others...
>>
>> The fact that only 127 bytes was corrupt is very odd. It would be
>> easier to understand if an entire page were bad, or an entire rsize
>> chunk.
>>
>> If you are able to reproduce this again, it might be helpful to see =
if
>> that's consistent. Try to nail down the nature of the corruption -- =
see
>> how much is different and where the different parts are. That may
>> help shed light on the problem...
>>
>> In any case, this will probably take some digging -- we should proba=
bly
>> open a bug at bugzilla.samba.org and start working on this there.
>> Pavel, would you mind doing that when you have time?
>>
>> Thanks,
>> --
>> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>
> So, after a closer investigating of the problem I figured out that:
>
> 1) It always reproduces after I boot the OS, load module, mount share
> and read the existing file.
>
> 2) Network traffics that are caught by wireshark on the server
> (Windows 7) and the client are different - I checked it and found the
> same difference in response packets for the area that is different on
> orig and orig.tmp files (the response packet from the capture on the
> server was true and the response packet from the capture on the clien=
t
> was failed).
>
> 3) The different area is always 128 bytes bounded but appears in
> different places.
>
> 4) It doesn't depends on a maybe broken LAN cable - I used two
> different ones with the same results.
>
> So, I don't think that it's cifs module issue and there is no need to
> open a bug on bugzilla.samba.org. It seems that it's the problem with
> the network driver or with the LAN card from my laptop.
>
> Make sense?

Yes ... but it brings up the obvious question ... what happens if cifs
signing is turned on?


--=20
Thanks,

Steve
