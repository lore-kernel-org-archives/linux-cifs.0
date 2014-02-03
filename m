From: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Subject: Re: Problem with connecting to SMB server in 3.9.11 kernel.
Date: Mon, 03 Feb 2014 09:54:11 -0800
Message-ID: <52EFD7C3.9020505@candelatech.com>
References: <52DAB72C.9030305@candelatech.com> <CADT32eL4na+eduUmmWKHe5usN+S2aN+mCUQqU5j8RHaq-3ZVwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"Amit Haval (India Bangalore)" <amit.haval-ZIEO9HjW1UBWk0Htik3J/w@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eL4na+eduUmmWKHe5usN+S2aN+mCUQqU5j8RHaq-3ZVwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 01/26/2014 10:07 PM, Shirish Pargaonkar wrote:
> Can you try this patch and see if it works?

We have verified that this works in our test systems.
We are just passing user=foo,password=bar in our
mount options, so hopefully that is sufficient to exercise this
code?

Thanks,
Ben

> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index e87387d..ac14d71 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -450,9 +450,8 @@ int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>         sec_blob->WorkstationName.MaximumLength = 0;
>         tmp += 2;
> 
> -       if (((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_KEY_XCH) ||
> -               (ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_EXTENDED_SEC))
> -                       && !calc_seckey(ses)) {
> +       if ((ses->ntlmssp->server_flags & NTLMSSP_NEGOTIATE_KEY_XCH) &&
> +                       !calc_seckey(ses)) {
>                 memcpy(tmp, ses->ntlmssp->ciphertext, CIFS_CPHTXT_SIZE);
>                 sec_blob->SessionKey.BufferOffset = cpu_to_le32(tmp - pbuffer);
>                 sec_blob->SessionKey.Length = cpu_to_le16(CIFS_CPHTXT_SIZE);

-- 
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Candela Technologies Inc  http://www.candelatech.com
