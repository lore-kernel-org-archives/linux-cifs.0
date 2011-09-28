From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mounts to Windows 7 and "out of memory" or "insufficient server resources"
Date: Wed, 28 Sep 2011 13:25:07 -0500
Message-ID: <CAH2r5mv8H0esXPdCe2Uuo-TUXas-wZSJWvF3K=iUBS-pYaO4rA@mail.gmail.com>
References: <CAH2r5msivsE_47mESmGR=Xjf2v-kKwi-Qpym2kxuTLPbYudisQ@mail.gmail.com>
	<20110928080027.2c04b12d@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110928080027.2c04b12d-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 28, 2011 at 7:00 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 27 Sep 2011 16:36:22 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> FYI - The cifs async write in 3.0 seems to exacerbate problems runni=
ng
>> out of memory (apparently) on the Windows 7 system (running as a
>> server) after a large file copy to the server completes. =A0 I have =
been
>> able to reproduce the same problem on Windows Vista Service Pack 2
>> (which is a good news/bad news story since my earlier testing on
>> Windows Vista showed hangs on some requests rather than returning ou=
t
>> of memory). =A0Does not seem to be a problem with any of the Windows
>> server versions just Windows 7 and Vista so far.
>>
>> As Pavel noted in an earlier note, increasing MaxWorkItems to 4096 i=
n
>> the Windows registry solves this.
>>
>> The cifs async write code does increase large file copy speed
>> dramatically (more than 15% in most environments) - but we are worki=
ng
>> through how to handle the Windows7/WindowsVista problem to see if
>> there are workarounds.
>>
>
> This is seems likely to be a cifs.ko bug -- it does not respect the
> MaxReq parm that the server sends in the negotiate and instead uses a
> hardcoded limit of 50 requests (which is tunable via module parm).
>
> What value is the server sending in the NEGOTIATE? Ensuring that
> cifs.ko doesn't exceed that value seems like a worthwhile endeavor.
> This is likely to be even worse soon when the async read patches are
> merged.

Yes, the client should not be exceeding the limit, but more testing
is needed of my earlier patch for that.


--=20
Thanks,

Steve
