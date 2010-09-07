From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH][ntlmv2 in ntlmssp 0/8] - resend in small chunks
Date: Tue, 7 Sep 2010 08:36:28 -0500
Message-ID: <AANLkTikLGZ8ociXVhwD1E77myR5+taL+9JtZJFG4cBd+@mail.gmail.com>
References: <1283830218-24939-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100907093445.0d6ff4f5@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100907093445.0d6ff4f5-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 7, 2010 at 8:34 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, =A06 Sep 2010 22:30:18 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> Make NTLMv2 as a default authentication mechanism within NTLMSSP
>>
>> Enable cifs/smb signing
>>
>> Use Crypto sync hash APIs instead of cifs crypto functions to genere=
ate
>> various hashes such as arc4/rc4, md5, and hmac-md5 used during authe=
ntication
>> and smb/cifs signature generation
>>
>
> The patches almost all lack real descriptions. I'm not sure whether
> that was intentional or not, but some of them could *really* use some
> explanation.

No, it was not inentional. Like the patch 8/8, I had comments/descripti=
on in all
of them.  Will make sure the next spin has the description.

>
> Also, I don't think this patchset is really complete yet. The last
> patch in this set should be "Remove old private CIFS crypto routines"=
=2E
> With the move to using the standard kernel crypto API, it seems like =
we
> should have a net reduction in code or at least something closer to 0=
=2E
> That would make it a lot easier to stomach taking in a large patchset
> like this.

I really would like to make it a separate patchset.  It would be really=
 cleaner
IMHO to separate it as anohter patch. I can do that before end of the y=
ear
but I do not have bandwidth right now to go through the entire code to
delete the now unused functions.

>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
