From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7 cifs] ntlm authentication and signing
Date: Wed, 29 Sep 2010 14:58:38 -0500
Message-ID: <AANLkTi=YK08e+1x+KmHGBfSGyxS73a9pv1Ob8aggaUWk@mail.gmail.com>
References: <1285771338-23272-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100929154247.579508c0@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100929154247.579508c0-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 29, 2010 at 2:42 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Wed, 29 Sep 2010 09:42:18 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> --
>> Fix broken NTLMv2 (without extended security) authentication mechanism.
>>
>> Enable cifs/smb signing
>>
>> Use Crypto sync hash APIs instead of cifs crypto functions to genereate
>> various hashes such as arc4/rc4, md5, and hmac-md5 used during authentication
>> --
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>
> Is this a new set of patches that's intended to be applied on top of
> the set you already sent? Or a respin of the remaining patches from the
> old set? It's not clear since there's no "version" on the patch posting.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> --

Jeff, new set of patches.  6/7 and 7/7 are almost identical to 3/4 and
4/4 in the prior patchset.
But I realized that ntlmv2 (without extended security) authenttication and
signing is broken. So mainly fixed with the related code change and
added code change
related to coming up with single mechanism to copy smb session session_key as
smb connection session_key (i.e. instead of using first_time for other
mechanisms and
cphready variable in ntlmssp).
