From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow nfsd over cifs
Date: Tue, 1 Mar 2011 12:30:12 -0600
Message-ID: <AANLkTikNH0ujA-qram1=1JEqJ7DH6dLRR723YZgJde1+@mail.gmail.com>
References: <1298929961-5541-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110228224957.GB14237@fieldses.org>
	<AANLkTimDd-m388VJTC1zJtf3Q7LkFcsvNuwcY6vRwt7K@mail.gmail.com>
	<20110228234225.GC14237@fieldses.org>
	<AANLkTikeSEYOs_nzno40eM0ZSrStMqcziPzWGRViT5M-@mail.gmail.com>
	<20110228235910.GD14237@fieldses.org>
	<AANLkTinFwcBMmPpn0_30Bjaa+0ipoJ6qrM=u1TGQ+Q8g@mail.gmail.com>
	<20110301032808.GA17725@fieldses.org>
	<20110301180700.GC20599@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110301180700.GC20599-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 1, 2011 at 12:07 PM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>=
 wrote:
> On Mon, Feb 28, 2011 at 10:28:08PM -0500, J. Bruce Fields wrote:
>> On Mon, Feb 28, 2011 at 08:33:08PM -0600, Steve French wrote:
>> > On Mon, Feb 28, 2011 at 5:59 PM, J. Bruce Fields <bfields@fieldses=
=2Eorg> wrote:
>> > > On Mon, Feb 28, 2011 at 05:52:09PM -0600, Steve French wrote:
>> > >> On Mon, Feb 28, 2011 at 5:42 PM, J. Bruce Fields <bfields@field=
ses.org> wrote:
>> > >> > OK. =A0Then as things stand we're stuck returning ESTALE to t=
he client
>> > >> > unless we happen to have the inode they're looking for in our=
 cache?
>> > >>
>> > >> Yes - that seems right and consistent with what I remember othe=
r file
>> > >> systems doing.
>> > >
>> > > No, other filesystems are able to look up the file on disk by in=
ode
>> > > number (or by whatever identifier they use in the filehandle). =A0=
They
>> > > don't depend on already having the inode in core.
>> >
>> > Grepping for ESTALE looks like there are dozens of places in vario=
us
>> > fs where ESTALE can get returned ...
>>
>> Certainly true.
>>
>> But they do have to be able to look up any inode, regardless of whet=
her
>> it is currently in cache.
>>
>> Otherwise applications on the client would see ESTALE after any serv=
er
>> reboot, or any time an inode was forced out of cache (for whatever
>> reason).
>>
>> That would be quite painful.
>
> So if my understanding of the cifs behavior here is correct, then I
> don't believe nfs exports of cifs will be usable.
>
> In the long term perhaps it could be possible with changes to one or =
the
> other of the protocols: for example, perhaps future versions of the n=
fs
> protocol could be made less reliant on long-lived filehandles. =A0But=
 that
> would be a major change.
>
> --b.
>

Bruce, I am not getting a picture of how NFS server would return ESTALE
error to nfs client and then on to the app for a filehandle fragment
that happens
to be coded as uniqueid by cifs during encode_fh if inode  with that un=
iqueid
does not happen to exist in vfs cache on the server box.

When nfs passes down  filehandle fragment (uniqueid) to cifs in fh_to_d=
entry,
if the inode does not exist in cache, cifs will pick a new inode and co=
py this
uniqueid as inode number.  Not sure what happens next for nfs server to
sense a stale file(handle fragment).
