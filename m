From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: CIFS: Add session setup/logoff capability for SMB2
Date: Wed, 19 Sep 2012 15:57:33 +0400
Message-ID: <CAKywueQmCNdDs5an6Jqe=TqHY6da42xRXqiU5q_264gFkr7SMQ@mail.gmail.com>
References: <20120919113120.GA32381@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120919113120.GA32381-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/9/19 Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>:
> Hello Pavel Shilovsky,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch 5478f9ba9a34: "CIFS: Add session setup/logoff capability
> for SMB2" from Dec 27, 2011, leads to the following Smatch complaint:
>
> fs/cifs/smb2pdu.c:672 SMB2_sess_setup()
>          warn: variable dereferenced before check 'rsp' (see line 657)
>
> fs/cifs/smb2pdu.c
>    656                  ses->Suid = rsp->hdr.SessionId;
>                                     ^^^^^^^^^^^^^^^^^^
> New dereference.
>
>    657                  rc = decode_ntlmssp_challenge(rsp->Buffer,
>    658                                  le16_to_cpu(rsp->SecurityBufferLength), ses);
>    659          }
>    660
>    661          /*
>    662           * BB eventually add code for SPNEGO decoding of NtlmChallenge blob,
>    663           * but at least the raw NTLMSSP case works.
>    664           */
>    665          /*
>    666           * No tcon so can't do
>    667           * cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[SMB2...]);
>    668           */
>    669          if (rc != 0)
>    670                  goto ssetup_exit;
>    671
>    672          if (rsp == NULL) {
>                     ^^^^^^^^^^^
> New check.
>
>    673                  rc = -EIO;
>    674                  goto ssetup_exit;
>
> regards,
> dan carpenter
>

Ok, it makes sense. Also I think we should remove all checks like:

if (rsp == NULL) {
        ...
}

because rsp can't be NULL in rc == 0 case.

-- 
Best regards,
Pavel Shilovsky.
