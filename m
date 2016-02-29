From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] s390x: fix condition to choose correct function
Date: Sun, 28 Feb 2016 22:16:24 -0600
Message-ID: <CAH2r5msH8u1oResunixLOM7zAj_UXXptAXg2_9AWiYKMi8F1Xg@mail.gmail.com>
References: <1456296347-9665-1-git-send-email-ydfan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench@samba.org>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>,
 LKML <linux-kernel@vger.kernel.org>, martin.schwidefsky@de.ibm.com
To: Yadan Fan <ydfan@suse.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1456296347-9665-1-git-send-email-ydfan@suse.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git

Looks like alpha has a similar problem though

On Wed, Feb 24, 2016 at 12:45 AM, Yadan Fan <ydfan@suse.com> wrote:

> This issue is involved from commit 02323db17e3a7 ("cifs: fix
> cifs_uniqueid_to_ino_t not to ever return 0"), when BITS_PER_LONG
> is 64 on s390x, the corresponding cifs_uniqueid_to_ino_t()
> function will cast 64-bit fileid to 32-bit by using (ino_t)fileid,
> because ino_t (typdefed __kernel_ino_t) is int type.
>
> Signed-off-by: Yadan Fan <ydfan@suse.com>
> ---
>  fs/cifs/cifsfs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 68c4547..02dcbe1 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -31,7 +31,7 @@
>   * so that it will fit. We use hash_64 to convert the value to 31 bits,
> and
>   * then add 1, to ensure that we don't end up with a 0 as the value.
>   */
> -#if BITS_PER_LONG == 64
> +#if BITS_PER_LONG == 64 && !defined(CONFIG_S390)
>  static inline ino_t
>  cifs_uniqueid_to_ino_t(u64 fileid)
>  {
> --
> 2.6.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Thanks,

Steve
