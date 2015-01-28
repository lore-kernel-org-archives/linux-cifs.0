From: Simo <simo@samba.org>
Subject: Re: The patents and license issue from microsoft regarding SMB
 implementation(GPL)
Date: Wed, 28 Jan 2015 09:07:34 -0500
Message-ID: <1422454054.32747.35.camel@samba.org>
References: <000801d03aa1$92475b40$b6d611c0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <000801d03aa1$92475b40$b6d611c0$@samsung.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Wed, 2015-01-28 at 11:24 +0900, Namjae Jeon wrote:
> Hi Folks,
> 
> I am planning to develop smb server for Linux kernel.
> Before starting on implemntation, want to clear patent related issue
> to know if it is legal to develop or not.

I have no idea about legal implications, and you'll get no answers here
for sure. Ask a lawyer. We can probably suggest a lawyer to consult with
if your lawyer needs help.

That said, an in kernel smb server is not really a bright idea, I would
think hard before going there, Solaris tried, went nowhere quickly.

Even if you get the SMB part of the protocols in kernel, you'll need so
many userspace helpers it is not even funny.
Better time would be spent analyzing what features in the kernel would
make Samba faster and use Samba.

Simo.

> When referring to the SAMBA site
> (https://www.samba.org/samba/PFIF/PFIF_history.html), I can see that there are
> a lot of legal obligations from the past. Like SAMBA, I also am just
> referring the Microsoft SPEC, while the implementation is all together different 
> due to obvious reasons (in-kernel implementation).
> As there is already an in kernel CIFS client, maybe CIFS developers had the same
> concern when developing CIFS client for Linux kernel ?
> But I'm not sure about the actual violation part.
> Maybe, I am wondering two problem.
>  1. When referring the Microsoft patent list, CIFS(SMB) and SMB2.0,
>     Microsoft have raised patent applications but this overall seems to be
>     about the implementation part. So, any implementation done on linux
>     with SMB specifications in mind and not following the approach of Microsoft
>     should not infringe any patents ?
>  2. While Samba have shifted to the GPLv3 with their newer version, but
>     I intend to make GPLv2.0 SMB server in kernel.
>     So implementation for this should not cause any license issues ?
> 
> Can you please help us in clearing the doubts ?
> 
> Thanks.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Simo Sorce
