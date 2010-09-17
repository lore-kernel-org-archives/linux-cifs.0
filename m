From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: question about CIFS client glitches
Date: Thu, 16 Sep 2010 19:19:54 -0500
Message-ID: <AANLkTinG8HBm2JgsFL=qLjJonKCRC7=1wAfbFz5p=oGD@mail.gmail.com>
References: <6.2.5.6.2.20100916171408.03a0fcd8@flumedata.com>
	<AANLkTimDWbZF=DkmVLw96V3nZGggFfNm0Zv3FxfFX1BE@mail.gmail.com>
	<6.2.5.6.2.20100916195402.0573dcc0@binnacle.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6.2.5.6.2.20100916195402.0573dcc0-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Sep 16, 2010 at 7:00 PM,  <starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org> wrote:
> At 05:50 PM 9/16/2010 -0500, Steve French wrote:
>>On Thu, Sep 16, 2010 at 4:39 PM, =A0<starlight-Utvwg/EOxnhfq8cQ1yknNg@public.gmane.org> wrote:
>>> Trying out a CIFS mount of a W2K8 x64 file system from CentOS
>>> 5.5 and running into problems, and trying to figure out how to
>>> proceed.
> ...
>>
>>This is quite old kernel, but perhaps it was updated to include more
>>recent fixes - can you view the version information on the file, ie
>>the cifs.ko module (you can do this by running modinfo on
>>cifs.ko)
>>
>
> Thank you for the follow-up. =A0Per my last message this was my
> being a clueless in regards to the lack of hard/soft link
> support in the old version. =A0'modinfo' pegs it as 1.60RH.
>
> Hopefully RHEL6 will include CIFS file links as it might work
> better to compile on Linux from a Windows share rather than
> vice-versa. =A0'makedepend' runs painfully slow from Windows over
> a Samba share unless IPoIB is used for transport.
>
> Perhaps I'll try it under Fedora, though in general I find
> wrestling with the constant change of the moving-target distro
> too much.
>
> It is quite encouraging to see CIFS work in general.

There is a lot of work going on :)

We (Jeff, Suresh, Shirish, Pavel and I and others) are doing over 200
changesets a year fixing/improving the cifs kernel module (and
hopefully will have a stable smb2 protocol kernel module for you next
year).



--=20
Thanks,

Steve
