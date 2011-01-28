From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [linux-cifs-client] can someone please explain the performance
 difference between mount.cifs and smbclient?
Date: Thu, 27 Jan 2011 21:19:24 -0600
Message-ID: <AANLkTin-9bGiWC-J52PEYJ1vrYrZ3Q4g8MBZB2eEbAYw@mail.gmail.com>
References: <20110127190719.72653d38@harpe.intellique.com>
	<20110127135410.6046a8cd@barsoom.rdu.redhat.com>
	<20110127230351.76e4940c@galadriel2.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Emmanuel Florac <eflorac-PuSHN2nxisHn0MxWRTiXmQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110127230351.76e4940c-CYgxBI+Q+g4ovfEj1NHgRQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Jan 27, 2011 at 4:03 PM, Emmanuel Florac <eflorac-PuSHN2nxisHfrJ4lp8Ex6g@public.gmane.org=
m> wrote:
> Le Thu, 27 Jan 2011 13:54:10 -0500 vous =E9criviez:
>
>> cc'ing linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org which is the new mailing list...
>
> Damn, that's why I wasn't receiving messages from the list for a few
> months :)
>
>> Most likely you're seeing the result of a lack of parallelism in the
>> Linux kernel cifs client. It does not do async writes (yet), which
>> really hinders throughput.
>>
>> I'm hoping to get to work on that in the next few months unless
>> someone else beats me to it...
>
> Thank you. In the meanwhile I'll probably stick to NFS :)
>

With NFSv4 you get similar caching to cifs, but there are
cases where our testing shows CIFS faster - but not for
single process, single file i/o.


--=20
Thanks,

Steve
