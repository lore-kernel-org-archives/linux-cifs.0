From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: [PATCH] cifs: Support for an upcall to map SID to an uid and a gid
Date: Tue, 14 Dec 2010 16:29:45 -0600
Message-ID: <AANLkTikAAeC=q0YVG5aCkzxZaKXAQuGAw7FG=NiA9iJU@mail.gmail.com>
References: <1291741872-22747-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101211111716.1e21be41@corrin.poochiereds.net>
	<AANLkTimiD_iAJveTFpsANQsJC_cUfRwHM=jO5FSoj4x_@mail.gmail.com>
	<20101211193003.4a11fc7f@corrin.poochiereds.net>
	<AANLkTiniGp28dxZuoTcjyp0OMEoQ-7E0yE6T8B+VHOLj@mail.gmail.com>
	<20101211221159.36e6c814@corrin.poochiereds.net>
	<1292125684.7313.4.camel@ruth>
	<20101212063929.77a619e4@tlielax.poochiereds.net>
	<1292210529.15637.10.camel@obed>
	<20101213061622.7e78e475@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: dhowells@redhat.com, smfrench@gmail.com, linux-cifs@vger.kernel.org,
	samba-technical <samba-technical@lists.samba.org>,
	Andrew Bartlett <abartlet@samba.org>
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20101213061622.7e78e475@tlielax.poochiereds.net>
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

On Mon, Dec 13, 2010 at 5:16 AM, Jeff Layton <jlayton@samba.org> wrote:
> On Mon, 13 Dec 2010 14:22:09 +1100
> Andrew Bartlett <abartlet@samba.org> wrote:
>
>> On Sun, 2010-12-12 at 06:39 -0500, Jeff Layton wrote:
>> > On Sun, 12 Dec 2010 14:48:04 +1100
>> > Andrew Bartlett <abartlet@samba.org> wrote:
>> >
>> > > On Sat, 2010-12-11 at 22:11 -0500, Jeff Layton wrote:
>> > > > On Sat, 11 Dec 2010 19:57:11 -0500
>> > > > Richard Sharpe <realrichardsharpe@gmail.com> wrote:
>> > > >
>> > > > > On Sat, Dec 11, 2010 at 7:30 PM, Jeff Layton <jlayton@samba.org>=
 wrote:
>> > > > > >>
>> > > > > >> Will look into this. =A0One thing that concerns me is if a ca=
ched etnry
>> > > > > >> for a SID with its name and an id (either an uid or a gid), i=
f that SID
>> > > > > >> now represents a different object and has differernt name, wo=
uld
>> > > > > >> not cached info be incorrect? =A0Not sure if this can ever ha=
ppen
>> > > > > >> or how would it happen and if it does, what would be a trigge=
r
>> > > > > >> for a cache revalidation and purges!
>> > > > > >>
>> > > > > >
>> > > > > > Sure, mappings can change. But, you still have the same proble=
m with
>> > > > > > what you're proposing in these patches. The userspace program =
isn't
>> > > > > > setting a timeout on the key. Once a mapping is put in the key=
ring,
>> > > > > > it's there until it's revoked. You probably want to set a max =
TTL for
>> > > > > > the entries in the cache regardless of what scheme is used.
>> > > > >
>> > > > > I was under the impression that SIDs are never reused. Perhaps I=
 am mistaken.
>> > > > >
>> > > >
>> > > > That may be, but the mapping of a SID is dependent upon settings i=
n
>> > > > config files that could change. It seems reasonable to me to only =
cache
>> > > > these mappings for a period of time in the event that they do. Tha=
t
>> > > > period of time could default to being rather long and be tunable.
>> > >
>> > > I think that instead some explicit signal should be made to indicate
>> > > that a mapping has changed, so you don't have to worry about cache
>> > > times. =A0It should change *very* rarely and only on specific
>> > > administrator intervention. =A0We do a lot of things to avoid this
>> > > happening in the normal course of events.
>> > >
>> >
>> > What would provide this signal? winbindd? I suppose we could add a kno=
b
>> > or something under /sys that tells cifs to dump the idmap cache.
>>
>> I think a /sys knob seems appropriate, perhaps easily sent a command
>> option on the same utility used for the upcall?
>>
>> > We would also have to consider however how to deal with someone runnin=
g
>> > an old winbindd that doesn't signal the kernel properly.
>>
>> That's a very interesting question, as after a manual reconfiguration
>> perhaps even winbind might not know it changed. =A0It depends how deeply
>> the administrator changed things (changing the idmap_rid config settings
>> might matter for example). =A0I'll let others who deal with idmap more
>> often comment.
>>
>
> The other option is just to have a manual knob that flushes the cache,
> and add something like this to the cifs.upcall manpage: "If you change
> your idmapping configuration, then you'll probably also want to flush
> the idmap cache." Maybe it's a rare enough thing that we shouldn't
> sweat trying to make it too automatic.
>
> --
> Jeff Layton <jlayton@samba.org>
>

# date; cat /proc/keys | grep cifs
Tue Dec 14 16:16:20 CST 2010
26fb212d I-----     1 perm 1f030000     0     0 keyring   .cifs_idmap: empt=
y
2fb33fb5 IR----     2 expd 1f030000     0     0 keyring   .cifs_idmap: empt=
y

# date; cat /proc/keys | grep cifs
Tue Dec 14 16:16:29 CST 2010
26fb212d I-----     1 perm 1f030000     0     0 keyring   .cifs_idmap: 2/4
2fb33fb5 IR----     2 expd 1f030000     0     0 keyring   .cifs_idmap: empt=
y

# date; cat /proc/keys | grep cifs
Tue Dec 14 16:20:10 CST 2010
26fb212d I-----     1 perm 1f030000     0     0 keyring   .cifs_idmap: 2/4
2fb33fb5 IR----     2 expd 1f030000     0     0 keyring   .cifs_idmap: empt=
y


Should not these two entries expire after a minute if

key->expiry =3D KEY_EXPIRY_TIMEOUT;

in function cifs_idmap_key_instantiate()

if

#define KEY_EXPIRY_TIMEOUT 60*HZ

I was expecting this to be empty instead of 2/4 after more than a minute
of inactivity.

26fb212d I-----     1 perm 1f030000     0     0 keyring   .cifs_idmap: 2/4
