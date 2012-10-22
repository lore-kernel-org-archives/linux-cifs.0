From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 2/2] cifs: Alternate Data Streams: Account for mount
 option mapchars
Date: Mon, 22 Oct 2012 07:06:58 -0500
Message-ID: <CADT32eKO3v7kuEy1vP_hHVmiBALdnEAJ0ASqwT1GRDvYN78G=A@mail.gmail.com>
References: <1350882092-6667-1-git-send-email-shirishpargaonkar@gmail.com>
	<CAFB9KM2S0xYiBXQ6OnSSdrNAz2-msF1GZaB9uDpnx=e524d-JQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM2S0xYiBXQ6OnSSdrNAz2-msF1GZaB9uDpnx=e524d-JQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 22, 2012 at 12:57 AM, Scott Lovenberg
<scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Oct 22, 2012 at 1:01 AM, <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> [...]
>> +       int remap;
>> +       char *altstr = NULL;
>> +       struct nls_table *cp;
>> +       struct tcon_link *tlink = NULL;
>> +       struct cifs_tcon *tcon = NULL;
>> +
>> +       cp = cifs_sb->local_nls;
>> +       remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
>> +
>> +       tlink = cifs_sb_tlink(cifs_sb);
>> +       if (tlink) {
>> +               tcon = tlink_tcon(tlink);
>> +               if (tcon && !(tcon->unix_ext))
>> +                       altstr = strchr(source, ':');
>> +               cifs_put_tlink(tlink);
>> +       }
>>
>> -       if (!mapChars)
>> +       if (!remap || altstr)
>>                 return cifs_strtoUTF16(target, source, PATH_MAX, cp);
>
> Would it make more sense for "remap" to be of type unsigned int or size_t?
>
>
> --
> Peace and Blessings,
> -Scott.

I think variable  remap   of type bool should be sufficient too.

Regards,

Shirish
