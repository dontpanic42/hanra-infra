UPDATE
    HanraSRItem
SET
    createdAt = (
        SELECT
            HanraCard.createdAt
        FROM
            HanraCard
        WHERE
            HanraCard.id = HanraSRItem.cardId
    );