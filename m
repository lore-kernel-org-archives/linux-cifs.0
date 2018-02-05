From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Work in progress SMB-Direct driver for the linux kernel
Date: Sun, 4 Feb 2018 19:32:34 -0600
Message-ID: <CAH2r5mufx5-eKKTr5quoPfyz0CuSTYcdK=0057OvLJS0sVEB4g@mail.gmail.com>
References: <959c3608-c508-17c4-bad6-fd9421a4a235@samba.org>
 <20180201175247.GT17053@ziepe.ca> <1517762353.3936.41.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>,
        Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Samba Technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517762353.3936.41.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Feb 4, 2018 at 10:39 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 2018-02-01 at 10:52 -0700, Jason Gunthorpe wrote:
>> On Thu, Feb 01, 2018 at 09:18:10AM +0100, Stefan Metzmacher wrote:
>>
>> > The first goal is to provide a socket fd to userspace (or in kernel
>> > consumers)
>> > which provides semantics like a TCP socket which is used as transport
>> > for SMB3. Basically frames are submitted with a 4 byte length header.
>>
>> Part of the point of RDMA is that we don't need to make protocol
>> specific kernel modules like this - is there a specific reason this
>> needs to be in the kernel like this?
>
> Although your question was partially answered, I think the precise cause
> is that to behave like an SMB3 server, the model involves opening a TCP
> connection, doing auth over that, then negotiating whether or not RDMA
> connections are possible, then opening the RDMA connections.  On our
> end, once the auth happens, smbd forks and the new user process handles
> the connection from that point on (which is integral to smbd's security
> model).  Because of this, and because the client initiates the RDMA
> connection and will only use a single well known port to connect to,
> incoming RDMA connections after negotiation would always go to the
> master smbd process and not the forked client authed smbd process.
> Because we don't have a way of then handing the RDMA connection from one
> process to another forked process, the model breaks down.  Possible
> solutions are:

It is interesting to think about the work Long Li did - which shows that
at least on the client side the model doesn't require opening a TCP
connection and doing auth on it before negotiating RDMA.

His smb3 kernel code allows trying SMB3 over RDMA immediately (without first
negotiating whether RDMA is allowed) - obviously finishing multichannel support
in cifs.ko is important, but I was surprised at first that it was
possible to use
RDMA for SMB3 without multichannel.


-- 
Thanks,

Steve
