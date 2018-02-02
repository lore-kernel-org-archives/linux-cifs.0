From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Work in progress SMB-Direct driver for the linux kernel
Date: Thu, 1 Feb 2018 19:00:22 -0800
Message-ID: <CACyXjPyKcLktNqEdBbicSd=3GU7R9BeE-=Dcc2DyCh2sH9wxMg@mail.gmail.com>
References: <959c3608-c508-17c4-bad6-fd9421a4a235@samba.org> <20180201175247.GT17053@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180201175247.GT17053-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Feb 1, 2018 at 9:52 AM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
> On Thu, Feb 01, 2018 at 09:18:10AM +0100, Stefan Metzmacher wrote:
>
>> The first goal is to provide a socket fd to userspace (or in kernel
>> consumers)
>> which provides semantics like a TCP socket which is used as transport
>> for SMB3. Basically frames are submitted with a 4 byte length header.
>
> Part of the point of RDMA is that we don't need to make protocol
> specific kernel modules like this - is there a specific reason this
> needs to be in the kernel like this?

If I had to guess it would be because Samba currently uses a fork
model ... it might be years before it gets to a completely threaded
model.

--=20
Regards,
Richard Sharpe
(=E4=BD=95=E4=BB=A5=E8=A7=A3=E6=86=82=EF=BC=9F=E5=94=AF=E6=9C=89=E6=9D=9C=
=E5=BA=B7=E3=80=82--=E6=9B=B9=E6=93=8D)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
