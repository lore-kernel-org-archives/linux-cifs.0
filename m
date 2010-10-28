From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] NTLM auth and sign - Use appropriate server challenge
Date: Thu, 28 Oct 2010 10:10:51 -0500
Message-ID: <AANLkTi=UdFFv3xO_wPGyDH+g08Acqy+BPn7uqMrPhthq@mail.gmail.com>
References: <1288210836-12380-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101027165619.512b50e8@tlielax.poochiereds.net>
	<AANLkTikx7cPwtbHP=pe4nYqS2EGz-CMa2wNPjZoqgLFg@mail.gmail.com>
	<AANLkTikseELkqD2_ztH0KF5qQL_95W+T+xq+Pe5Sbj-3@mail.gmail.com>
	<20101027193854.78c1b500@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101027193854.78c1b500-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 27, 2010 at 6:38 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 27 Oct 2010 16:20:48 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Wed, Oct 27, 2010 at 4:18 PM, Shirish Pargaonkar
>> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > On Wed, Oct 27, 2010 at 3:56 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
>> >> On Wed, 27 Oct 2010 15:20:36 -0500
>> >> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> >>
>> >>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>>
>> >>>
>> >>> Need to have cryptkey or server challenge in smb connection
>> >>> (struct TCP_Server_Info) for ntlm and ntlmv2 auth types for whic=
h
>> >>> cryptkey (Encryption Key) is supplied just once in Negotiate Pro=
tocol
>> >>> response during an smb connection setup for all the smb sessions=
 over
>> >>> that smb connection.
>> >>>
>> >>> For ntlmssp, cryptkey or server challenge is provided for every
>> >>> smb session in type 2 packet of ntlmssp negotiation, the cryptke=
y
>> >>> provided during Negotiation Protocol response before smb connect=
ion
>> >>> does not count.
>> >>>
>> >>> Rename cryptKey to cryptkey and related changes.
>> >>>
>> >>>
>> >>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>> ---
>> >>> =A0fs/cifs/cifsencrypt.c | =A0 10 +++++++---
>> >>> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A03 ++-
>> >>> =A0fs/cifs/cifssmb.c =A0 =A0 | =A0 =A04 ++--
>> >>> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A04 ++--
>> >>> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0| =A0 12 ++++++++----
>> >>> =A05 files changed, 21 insertions(+), 12 deletions(-)
>> >>>
>> >>
>> >> [...]
>> >>
>> >>>
>> >>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> >>> index 67d6a22..b736951 100644
>> >>> --- a/fs/cifs/cifsglob.h
>> >>> +++ b/fs/cifs/cifsglob.h
>> >>> @@ -196,6 +196,7 @@ struct TCP_Server_Info {
>> >>> =A0 =A0 =A0 int capabilities; /* allow selective disabling of ca=
ps by smb sess */
>> >>> =A0 =A0 =A0 int timeAdj; =A0/* Adjust for difference in server t=
ime zone in sec */
>> >>> =A0 =A0 =A0 __u16 CurrentMid; =A0 =A0 =A0 =A0 /* multiplex id - =
rotating counter */
>> >>> + =A0 =A0 char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, =
ntlmv2 etc */
>> >>> =A0 =A0 =A0 /* 16th byte of RFC1001 workstation name is always n=
ull */
>> >>> =A0 =A0 =A0 char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_=
NULL];
>> >>> =A0 =A0 =A0 __u32 sequence_number; /* needed for CIFS PDU signat=
ure */
>> >>> @@ -240,7 +241,7 @@ struct cifsSesInfo {
>> >>> =A0 =A0 =A0 char userName[MAX_USERNAME_SIZE + 1];
>> >>> =A0 =A0 =A0 char *domainName;
>> >>> =A0 =A0 =A0 char *password;
>> >>> - =A0 =A0 char cryptKey[CIFS_CRYPTO_KEY_SIZE];
>> >>> + =A0 =A0 char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlmss=
p */
>> >>
>> >> I'm trying to understand why we need ses->cryptkey at all. It hol=
ds the
>> >> cryptkey provided by the server only if we're using ntlmssp. It's
>> >> only used once, and essentially it just holds the key until we ha=
ve a
>> >> auth_key.response field that we can stuff this in. Is that correc=
t? If
>> >> so, wouldn't it make more sense to just allocate the auth_key.res=
ponse
>> >> field earlier and put this directly in there?
>> >>
>> >> --
>> >> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >>
>> >
>> > Jeff, we could do that. =A0We then have to allocate .response in f=
unction
>> > decode_ntlmssp_challenge(). =A0We have to worry about freeing it i=
f there
>> > are any errors between decode_ntlmssp_challenge() and setup_ntlmv2=
_response().
>> > In function setup_ntlmv2_rsp(), we have to allocate .response only=
 if called
>> > in case of ntlmv2 without extended security, so an extra if statem=
ent in there.
>> >
>> > I think current code is simpler for the price of 16 bytes of crypt=
key storage?
>> >
>>
>> Not 16, 8 bytes. =A0 CIFS_CRYPTO_KEY_SIZE is 8 bytes, I thought it w=
as 16 bytes.
>
> I don't think that's simpler. I'm becoming concerned about the
> proliferation of fields in cifsSesInfo. All of these are recent
> additions by your patches to fix NTLMSSP support.
>
> =A0 =A0 =A0 =A0char cryptKey[CIFS_CRYPTO_KEY_SIZE];
> =A0 =A0 =A0 =A0struct session_key auth_key;
> =A0 =A0 =A0 =A0char ntlmv2_hash[16];
> =A0 =A0 =A0 =A0unsigned int tilen; /* length of the target info blob =
*/
> =A0 =A0 =A0 =A0unsigned char *tiblob; /* target info blob in challeng=
e response */
> =A0 =A0 =A0 =A0struct ntlmssp_auth ntlmssp; /* ciphertext, flags */
>
> ...it's not so much the space that they take up, even though that's n=
ot
> exactly trivial. A lot of these fields have no use at all after
> authentication is done. There's a lot of memcpy'ing going on here too
> which is a red flag.
>
> It's not clear to me why you need so many fields for this. It would
> seem to me that it would be a good idea to think about each of these
> fields and determine which ones need to stick around after
> authentication is done (i.e. for signing), and store the rest of them
> in a structure that can be freed after authentication is done.
>
> My main concern here is debugging this later. One of the main
> techniques I use when tracking down bugs is to follow the lifecycle o=
f
> the data. Whenever you add a new field, it makes it a lot more
> difficult for myself and others to follow the code.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Posted a follow up patch that addresses the concerns.  If that patch
is agreeable in
some or no additional variations, it should follow this patch if this
patch is good enough
because the functionality in this patch is needed for multiple smb
sessions per smb connection.
