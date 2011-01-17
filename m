From: Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH] CIFS: Fix oplock break handling
Date: Mon, 17 Jan 2011 16:38:50 +0300
Message-ID: <AANLkTimGaiTM0RFQk_ykLy6v4ixif7n-3HjVcAeFBkrs@mail.gmail.com>
References: <1295027561-24077-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: stable@kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <stable-bounces@linux.kernel.org>
In-Reply-To: <1295027561-24077-1-git-send-email-piastryyy@gmail.com>
List-Unsubscribe: <http://linux.kernel.org/mailman/options/stable>,
	<mailto:stable-request@linux.kernel.org?subject=unsubscribe>
List-Archive: <http://linux.kernel.org/mailman/private/stable/>
List-Post: <mailto:stable@linux.kernel.org>
List-Help: <mailto:stable-request@linux.kernel.org?subject=help>
List-Subscribe: <http://linux.kernel.org/mailman/listinfo/stable>,
	<mailto:stable-request@linux.kernel.org?subject=subscribe>
Sender: stable-bounces@linux.kernel.org
Errors-To: stable-bounces@linux.kernel.org
List-Id: linux-cifs.vger.kernel.org

2011/1/14 Pavel Shilovsky <piastryyy@gmail.com>:
> When we get oplock break notification we should set the appropriate
> value of OplockLevel field in oplock break acknowledge according to
> the oplock level held by the client in this time. As we only can have
> level II oplock or no oplock in the case of oplock break, we should be
> aware only about clientCanCacheRead field in cifsInodeInfo structure.
>
> Also fix bug connected with wrong interpretation of OplockLevel field
> during oplock break notification processing.
>
> Signed-off-by: Pavel Shilovsky <piastryyy@gmail.com>
> Cc: <stable@kernel.org>

What's about this?

-- 
Best regards,
Pavel Shilovsky.
