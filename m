From: Steve French <smfrench@gmail.com>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Thu, 10 Mar 2011 07:53:25 -0600
Message-ID: <AANLkTimO6Z7hoDx3wzv7JB-Hj=yzJrADFDE5oSqooaau@mail.gmail.com>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
	<20110309215148.GW15097@dastard>
	<AANLkTinDmqah6pQnHugoVxh-gDq+6+MDMuh-TyVAQ7LP@mail.gmail.com>
	<20110309185427.7858c29b@corrin.poochiereds.net>
	<AANLkTi=pXHjE6tNMm0_nO=Cn3nGH8oZ6Xhm1STh8x1Xe@mail.gmail.com>
	<20110309203044.4fd0498e@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david@fromorbit.com>, linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <mcao@us.ibm.com>
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110309203044.4fd0498e@corrin.poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, Mar 9, 2011 at 7:30 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Wed, 9 Mar 2011 18:33:20 -0600
> Steve French <smfrench@gmail.com> wrote:
>
>> On Wed, Mar 9, 2011 at 5:54 PM, Jeff Layton <jlayton@redhat.com> wro=
te:
>> > On Wed, 9 Mar 2011 16:01:30 -0600
>> > Steve French <smfrench@gmail.com> wrote:
>> >
>> >>
>> >> Except we don't need to wait that long with the page locked
>> >> ie for a response from the cifs server (such as Samba or Windows
>> >> or NetApp), just need to wait for it to get on the wire.
>> >> Waiting for us to get the server response would
>> >> take 10 or 100 times longer. =A0 In any case we can't resend
>> >> the same request to the server (the signature changes on the
>> >> resend since the sequence number is incremented on every
>> >> request/response so we have to recalc the checksum anyway) and
>> >> cifs requests can't get lost (as with nfs over udp). =A0Keeping
>> >> a page locked for 10milliseconds seems like a bad idea - but
>> >> it is a little more complicated to implement (for the cifs case)
>> >> so that we end page writeback (for the non-WB_SYNC)
>> >> as quickly as reasonably possible so we don't kill perf.
>> >>
>> >
>> > The problem here is that the socket layer doesn't have a mechanism
>> > to notify us of a TCP ACK. So, we have to wait for the next-best t=
hing
>> > -- a response from the server.
>>
>> But ... we can stop writeback as soon as kernel_sendmsg returns - on=
ce
>> we return from kernel_sendmsg the buffers can (and often will) be
>> freed so we know those pages could not still be used by tcp =A0(belo=
w
>> cifs) once kernel_sendmsg returns. =A0We can minimize the delay furt=
her
>> by making sure we set TCP_NODELAY on the socket (we probably ought t=
o
>> make that the default instead of an option).
>>
>
> That's not correct. A return from kernel_sendmsg just means that the
> data has been buffered up, not that it has been sent and acked. We
> shouldn't use that as an indicator to mean that the pages no longer
> need to be stable.

We can't free the page from the cache until the server responds that
it has written the data (otherwise if the server crashes we have no
way to resend the dirty page), but I don't see any reason to block redi=
rtying
a page as long as we don't break the signing mechanism.  We can allow w=
rites to
a page once the page has been buffered (kernel_sendmsg is complete).
Although cifs has stricter (stricter than open to close) guarantees tha=
n nfs
in some case, we could hang on to pages longer as nfs does until the se=
rver
returns the equivalent of fsync.



--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
