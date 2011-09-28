From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mounts to Windows 7 and "out of memory" or "insufficient server resources"
Date: Wed, 28 Sep 2011 13:28:38 -0500
Message-ID: <CAH2r5msGzs65HO_YuuUzhp3RNo+rJEB=ey8Hx5=1r=bpWpjWLA@mail.gmail.com>
References: <CAH2r5msivsE_47mESmGR=Xjf2v-kKwi-Qpym2kxuTLPbYudisQ@mail.gmail.com>
	<CADT32eLk5N4WJCMdtcd3MTgR39fCTn4_gQqqobYsxkpcPnfuDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLk5N4WJCMdtcd3MTgR39fCTn4_gQqqobYsxkpcPnfuDQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 28, 2011 at 4:30 AM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Sep 27, 2011 at 4:36 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
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
>> server versions just Windows 7 and Vista so far
>
> If this is a problem with Windows Vista and Windows 7, it is likely
> to be a problem with Windows 2008 Server as well.
> Basically Windows server starting Vista perhaps?

I have not been able to reproduce it against Windows 2003
or Windows 2008 server yet, but plan some experiments.
If you have additional test data on this let me know.


--=20
Thanks,

Steve
