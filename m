From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mids and cifs sendrcv2
Date: Tue, 26 Apr 2011 23:40:41 +0400
Message-ID: <BANLkTimZN_P96PFaP9oNyMbaHK5Of4WFYw@mail.gmail.com>
References: <BANLkTi=tUrieqB4jCo0GRX3Np10JxJUP9Q@mail.gmail.com>
	<BANLkTikLfy=4BPESJEmOe+mBhKSRtC=W6A@mail.gmail.com>
	<BANLkTiknBBtzjEjXK5N=SpUaU=b4GAos_A@mail.gmail.com>
	<BANLkTik2OVULuf1bt2_5J7L6MqmwMQCJ5w@mail.gmail.com>
	<20110422114526.GA31546@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110422114526.GA31546-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/22 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>:
> On Fri, Apr 22, 2011 at 02:33:08PM +0400, Pavel Shilovsky wrote:
>> I've just thought about to share tcp_server_info struct between
>> different protocol connections. So, we can use cifs and smb2
>> connection on the same server and don't keep two socket connections.
>> What do you think about to store protocol_id in ses_info rather that
>> tcp_server_info?
>
> What about prototyping it either first, and then review an actually
> complete smb2 implementation on a branch / as a patchkit do decide
> what makes most sense?

Yes, you are right. I am going to create such a branch and start to
merge smb2 code there.

-- 
Best regards,
Pavel Shilovsky.
