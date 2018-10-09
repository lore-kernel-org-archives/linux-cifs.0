From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH v2] smb2: fix uninitialized variable bug in
 smb2_ioctl_query_info
Date: Tue, 9 Oct 2018 23:53:17 +0200
Message-ID: <507142d7-d630-8eb3-9e0a-b2fa90e38d23@embeddedor.com>
References: <20181009201748.GA21025@embeddedor.com>
 <716967702.32689579.1539121620152.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Ronnie Sahlberg <lsahlber@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <716967702.32689579.1539121620152.JavaMail.zimbra@redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hey Ronnie,

On 10/9/18 11:47 PM, Ronnie Sahlberg wrote:
> Good catch, but I think it should be :
> 
> int resp_buftype = CIFS_NO_BUFFER;
>

Oh okay. I'll send v3 shortly.

Thanks for the feedback.
--
Gustavo
