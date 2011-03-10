From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Thu, 10 Mar 2011 07:44:17 -0600
Message-ID: <AANLkTin4_TeJLZHdHFvsycMo=z=8uDwd5xjgy6Y0VMfE@mail.gmail.com>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
	<20110309215148.GW15097@dastard>
	<AANLkTinDmqah6pQnHugoVxh-gDq+6+MDMuh-TyVAQ7LP@mail.gmail.com>
	<1299721264.2976.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Mingming Cao <mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299721264.2976.3.camel-rJ7iovZKK19ZJLDQqaL3InhyD016LWXt@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Mar 9, 2011 at 7:41 PM, Trond Myklebust
<Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 2011-03-09 at 16:01 -0600, Steve French wrote:
>> On Wed, Mar 9, 2011 at 3:51 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> w=
rote:
>> > On Wed, Mar 09, 2011 at 01:44:24PM -0600, Steve French wrote:
>> >> Following up on the discussion about how to avoid the copy into a
>> >> temporary buffer for the case when a file system has to sign a pa=
ge
>> >> (or list of pages) that is going to be passed in an iovec to be
>> >> written to the network or disk, I noticed that a few file systems=
 do
>> >> issue wait_on_page_writeback (nfs in nfs_writepages for example).
>> >> Apparently some areas are being investigated to add something sim=
ilar
>> >> for ext4 for disk adapters that do crc checks on data being sent =
down
>> >> to the disk. =A0 In the cifs case it looks like cifs_writepages a=
lready
>> >> does:
>> >>
>> >> if (wbc->sync_mode !=3D WB_SYNC_NONE)
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 w=
ait_on_page_writeback(page);
>>
>> <snip>
>>
>> > Sounds like a case for the same dirty page lifecycle as NFS: clean
>> > -> dirty -> writeback -> unstable -> clean. i.e. the page is
>> > unstable after the issuing of the IO until the response from the
>> > server so the page can't be reclaimed while the IO is still in
>> > progress at the server...
>>
>> Except we don't need to wait that long with the page locked
>> ie for a response from the cifs server (such as Samba or Windows
>> or NetApp), just need to wait for it to get on the wire.
>> Waiting for us to get the server response would
>> take 10 or 100 times longer. =A0 In any case we can't resend
>> the same request to the server (the signature changes on the
>> resend since the sequence number is incremented on every
>> request/response so we have to recalc the checksum anyway) and
>> cifs requests can't get lost (as with nfs over udp). =A0Keeping
>> a page locked for 10milliseconds seems like a bad idea - but
>> it is a little more complicated to implement (for the cifs case)
>> so that we end page writeback (for the non-WB_SYNC)
>> as quickly as reasonably possible so we don't kill perf.
>
> So what if the server crashes, or you get some other transient error?
>
> The NFS unstable write mechanism is there in order to deal with
> imperfect servers that occasionally crash and lose cached data. If al=
l
> we had to deal with was perfect situations where all WRITE requests
> succeed, then life would be much simpler...

If the server crashes we have to resend a new request with a different
sequence number so the signature changes - so it doesn't
matter if the page was mmapped and modified we will have to recalculate
the crc anyway.



--=20
Thanks,

Steve
