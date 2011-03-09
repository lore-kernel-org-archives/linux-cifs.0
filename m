From: Steve French <smfrench@gmail.com>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Wed, 9 Mar 2011 16:01:30 -0600
Message-ID: <AANLkTinDmqah6pQnHugoVxh-gDq+6+MDMuh-TyVAQ7LP@mail.gmail.com>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
	<20110309215148.GW15097@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <mcao@us.ibm.com>,
	Jeff Layton <jlayton@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110309215148.GW15097@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, Mar 9, 2011 at 3:51 PM, Dave Chinner <david@fromorbit.com> wrot=
e:
> On Wed, Mar 09, 2011 at 01:44:24PM -0600, Steve French wrote:
>> Following up on the discussion about how to avoid the copy into a
>> temporary buffer for the case when a file system has to sign a page
>> (or list of pages) that is going to be passed in an iovec to be
>> written to the network or disk, I noticed that a few file systems do
>> issue wait_on_page_writeback (nfs in nfs_writepages for example).
>> Apparently some areas are being investigated to add something simila=
r
>> for ext4 for disk adapters that do crc checks on data being sent dow=
n
>> to the disk. =A0 In the cifs case it looks like cifs_writepages alre=
ady
>> does:
>>
>> if (wbc->sync_mode !=3D WB_SYNC_NONE)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait=
_on_page_writeback(page);

<snip>

> Sounds like a case for the same dirty page lifecycle as NFS: clean
> -> dirty -> writeback -> unstable -> clean. i.e. the page is
> unstable after the issuing of the IO until the response from the
> server so the page can't be reclaimed while the IO is still in
> progress at the server...

Except we don't need to wait that long with the page locked
ie for a response from the cifs server (such as Samba or Windows
or NetApp), just need to wait for it to get on the wire.
Waiting for us to get the server response would
take 10 or 100 times longer.   In any case we can't resend
the same request to the server (the signature changes on the
resend since the sequence number is incremented on every
request/response so we have to recalc the checksum anyway) and
cifs requests can't get lost (as with nfs over udp).  Keeping
a page locked for 10milliseconds seems like a bad idea - but
it is a little more complicated to implement (for the cifs case)
so that we end page writeback (for the non-WB_SYNC)
as quickly as reasonably possible so we don't kill perf.


>> Have alternative approaches, other than using wait_on_page_writeback=
,
>> been considered for solving the stable page write problem in similar
>> cases (since only about 1 out of 5 linux file systems uses this call
>> today).
>
> I think that is incorrect. write_cache_pages() does:
>
> =A0929 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lock_page(page=
);
> .....
> =A0950 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (PageWriteb=
ack(page)) {
> =A0951 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 if (wbc->sync_mode !=3D WB_SYNC_NONE)
> =A0952 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 wait_on_page_writeback(page);

aaah - right. that makes sense.



--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
