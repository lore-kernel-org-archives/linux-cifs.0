From: Steve French <smfrench@gmail.com>
Subject: Re: [patch] cifs: accidentally creating empty files
Date: Sat, 29 Oct 2011 17:03:46 -0500
Message-ID: <CAH2r5muq4n34Liy_=CQQX-PeTinJFDAPi81fA-eqsTcXw5remQ@mail.gmail.com>
References: <20110927212810.GA12900@elgon.mountain>
	<20111013132755.6c5db87e@barsoom.rdu.redhat.com>
	<CAH2r5mtOF=Ja7_mTK576uEqgZqaVH+8YXtOqmZVknBC81sD=8Q@mail.gmail.com>
	<20111028072019.GA14900@longonot.mountain>
	<CAH2r5msb_+tenSg1kWCn_0xi2EZu6vboqvmbQ17vRBYoqHp2Eg@mail.gmail.com>
	<20111028234406.01fd23ba@corrin.poochiereds.net>
	<CAH2r5mvHF0X6PQ8FyBfVEpQeyWgd7RGkawJykapkKt0K84QTHw@mail.gmail.com>
	<20111029014855.13dd53be@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, Dan Carpenter <dan.carpenter@oracle.com>
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20111029014855.13dd53be@corrin.poochiereds.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Sat, Oct 29, 2011 at 12:48 AM, Jeff Layton <jlayton@samba.org> wrote:
> On Sat, 29 Oct 2011 00:07:12 -0500
> Steve French <smfrench@gmail.com> wrote:
>
>> On Fri, Oct 28, 2011 at 10:44 PM, Jeff Layton <jlayton@samba.org> wrote:
>> > On Fri, 28 Oct 2011 10:27:04 -0500
>> > Steve French <smfrench@gmail.com> wrote:
>> >
>> >> On Fri, Oct 28, 2011 at 2:20 AM, Dan Carpenter <dan.carpenter@oracle.=
com> wrote:
>> >> > On Wed, Oct 19, 2011 at 09:14:37PM -0500, Steve French wrote:
>> >> >> Doesn't this force the create to happen later - rather than
>> >> >> at lookup time where it belongs?
>> >> >>
>> >> >> if the issue is just noperm ... we should let this through if the =
user
>> >> >> has local permissions. =A0Doubling the cost of a file create to Sa=
mba
>> >> >> seems like a bad idea (ie doing aQueryPathInfo AND an NTCreateX
>> >> >> doubles the roundrip, doubles the load on the server etc.) - the w=
hole
>> >> >> point of this is to let us do an "atomic" open or create operation
>> >> >> and not have to split it into multiple requests. =A0In any case wh=
y would
>> >> >> we do the open and then follow it with a create?
>> >> >>
>> >> >> Can we fix this to (at least) narrow the performance penalty.
>> >> >>
>> >> >
>> >> > Yes, it does add another back and forth to file create... =A0It's h=
ard/
>> >> > impossible to check the permissions first and then decide whether t=
o
>> >> > pass the O_CREAT flag. =A0Maybe we could add an if statement to che=
ck
>> >> > whether noperm was used and the noperm version could use the create
>> >> > on lookup.
>> >>
>> >> Why is it hard to check local permissions? We have the local mode
>> >> for the parent.
>> >>
>> >> Also note that the "intent" flags and the atomic create is not just
>> >> about performance, but also making it atomic reduces some of the weir=
d
>> >> failure cases.
>> >>
>> >
>> > We have the local mode for the parent, but we do not have the ownershi=
p
>> > and mode for the file that has not yet been created. Because of the
>> > special (ahem) way that cifs handles permissions, it's easily possible
>> > for the ownership of the file not to match the user doing that create.
>> > At that point, later operations on the file can easily fail.
>> >
>> > This was the primary reason for the multiuser patch series, and why I
>> > still say that doing permissions checking on the client is a broken
>> > model.
>>
>> We don't have much choice - we have to allow permission
>> checking on the client when client security context
>> can't match security context on server - but I would like
>> to make multiuser the default (especially if we
>> can figure out a way to integrate winbind-like
>> upcall for ntlmv2 auth) at least for the future (smb2 etc.)
>> even if we can't change the default for cifs mounts.
>>
>
> That's fine, but that doesn't solve Dan's immediate problem. We need to
> either take his patch or something like it for 3.2 (and probably for
> stable as well) or just rip this crap out altogether.

The benchmark gains are huge for a couple test cases
(e.g. creating lots of small files) - doesn't make sense to throw it out.
At worst (I think we can do better) - we only give up on atomic
open/create for when noperm is not set (we want our users
to be running noperm or equivalently multiuser).   It is especially
important since the servers we do best at with create turn out
to be Linux ( and other Unix which Samba runs on (due to posix extensions))=
.

If we break create apart as you suggest - we run into
lookup/getattr/create/open/setattr
races which are also annoying - we are supposed to send an atomic
create/open operation
to minimize strange consequences if the server file changes in between
(the alternative)
where getattr/create/open/setattr is done.




--=20
Thanks,

Steve
